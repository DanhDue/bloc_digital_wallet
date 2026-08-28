# Translation Cache-First Apply + Delta Parsing Fix

## Context

This follows directly on two earlier fixes in the same session:

- **Fix A** (`SettingsBloc._onChangeLanguage`): the locale now switches immediately
  (optimistic UI update) instead of being gated on the backend translation fetch
  succeeding. This fixed the reported "cannot switch to ko_KR" bug, but it only
  reaches the *bundled/static* slang translations — it does not apply any
  previously-synced dynamic-override JSON that may already be cached on disk.
- **Fix B** (`SettingsLocalDataSourceImpl`): translation version and checksum are
  now written together atomically and validated on every cache read, so a
  desynced cache is detected and treated as corrupt rather than silently trusted.

While investigating a follow-up question ("apply cached translation first, then
apply what changed"), tracing the actual wire contract in
`packages/settings/docs/user_preferences_sync_api.md` §3.2 against the client
code uncovered a deeper, pre-existing bug: the delta-fetch response is parsed
incorrectly, and this is shared code both the bootstrap-sync path and the
Settings on-demand language-switch path depend on.

## Problem

### Problem 1 — No cache-first apply on language switch (UX)

`GetDynamicLocalizationUseCase` (used by `SettingsBloc._onChangeLanguage`) always
waits for the network fetch to resolve before anything is applied via
`LocalizationManager.applyDynamicTranslations`. If a previously-synced
dynamic-override JSON for that language is already cached on disk, the user
still waits for the network round-trip before seeing it — even though it's
already available locally.

### Problem 2 — Delta responses are parsed incorrectly (correctness)

The documented delta response shape (`GET /api/v1/translations/{lang}?since_version=...`)
is:

```json
{
  "data": {
    "mode": "delta",
    "version": "1.0.5",
    "checksum": "a8f5f167f44f4964e6c998dee827110c",
    "changes": { "settings": { "security": "Security (Updated)" } },
    "deleted_keys": ["settings.developer.debugMode"]
  }
}
```

`SettingsRemoteDataSource.getLocalizationOverrides` only ever looks for a
`translations` key on the inner data object. That key does not exist in delta
mode (the payload is under `changes`), so parsing falls into an `else` branch
that assigns the **entire** inner data object — `mode`, `version`,
`since_version`, `checksum`, `changes`, `deleted_keys`, all of it, unflattened —
to `TranslationOverrideData.translations`. `version` is also never read in this
path, silently defaulting to `'1.0.0'`.

Both `FetchTranslationUseCase` (bootstrap sync) and `GetDynamicLocalizationUseCase`
(Settings language switch) call this same method and read `.translations` off
the same model, so **both** are corrupted identically whenever the server
answers in delta mode — which is most requests after the first fetch for a
given language.

`FetchTranslationUseCase` additionally decides full-vs-delta from
`item.mode` — a classification made in advance by the bootstrap response —
rather than the actual response's own `mode`. Per the documented contract, the
server may fall back to a full response (`mode: "full"`,
`X-Delta-Unavailable: true`) even when delta was requested (deltas pruned).
Trusting `item.mode` over the response's `mode` mishandles this fallback.

## Design

### 1. Shared parsing/model fix

`TranslationOverrideData` gains three fields:
- `mode` (`String`, `'full'` or `'delta'`)
- `deletedKeys` (`List<String>`, default empty)
- `checksum` (`String?`)

`SettingsRemoteDataSource.getLocalizationOverrides` is rewritten to branch on
the inner data object's `mode`:
- `'full'` (or an unrecognized/legacy shape without `mode`, for backward
  compatibility) → `translations = innerData['translations'] ?? {}`.
- `'delta'` → `translations = innerData['changes'] ?? {}`,
  `deletedKeys = (innerData['deleted_keys'] as List?)?.cast<String>() ?? []`.

`translations` keeps its name and is populated from whichever source key
applies, so callers keep reading one field — "the content to apply" — and use
`mode` to know how to interpret it.

`version` and `checksum` are read unconditionally from the inner data object,
not gated behind the presence of a `translations` key.

### 2. Shared merge helper

A new pure function (e.g. `TranslationOverrideMerger.apply(cachedJson, overrideData)`):
- `mode == 'full'` → returns `overrideData.translations` outright (ignores `cachedJson`).
- `mode == 'delta'` → `DeepMergeUtils.deleteKeys(DeepMergeUtils.deepMerge(cachedJson ?? {}, overrideData.translations), overrideData.deletedKeys)`.

Both usecases call this instead of maintaining their own copy of this logic —
removing the duplication that let the two paths drift out of sync in the
first place.

### 3. `FetchTranslationUseCase` (bootstrap) — targeted change

- Keep using `item.mode` to decide whether to *request* delta (i.e. whether to
  send `sinceVersion`) — this is a valid request-side signal from the
  bootstrap classification and is unchanged.
- Switch the *response-side* merge decision to the shared helper, driven by
  `overrideData.mode` (the actual response), not `item.mode` — correctly
  handles the documented delta-unavailable-fallback-to-full case.
- Existing post-merge checksum validation (against `item.checksum`, with
  fallback to a full refetch on mismatch) is unchanged in shape, now finally
  operating on correctly parsed content.

### 4. `GetDynamicLocalizationUseCase` (Settings language switch) — cache-first + correct delta + checksum parity

1. Read cached version + cached JSON (as today).
2. **New:** if cached JSON exists, apply it immediately via
   `LocalizationManager.applyDynamicTranslations` — before the network call.
   This is the instant, no-network-wait paint the user asked for.
3. Fetch via `getLocalizationOverrides(sinceVersion: cachedVersion, eTag: checksum)`
   — request shape unchanged.
4. **304** → nothing further needed; step 2 already applied the cache. (Today's
   redundant "reload from cache and apply" branch on 304 is dropped since it's
   now a no-op duplicate of step 2.)
5. **Success** → merge via the shared helper (§2), driven by `overrideData.mode`.
6. **New — checksum parity:** compute the checksum of the merged result and
   compare against `overrideData.checksum` (when the server provided one). On
   mismatch, treat the merge as corrupted: delete the cache entry and perform
   one full refetch (`getLocalizationOverrides(languageCode)`, no
   `sinceVersion`), mirroring `FetchTranslationUseCase`'s existing mismatch
   handling. This guards specifically against a bad delta merge (e.g. a stale
   cache basis) producing a result that is internally self-consistent for
   Fix B's checksum but still wrong relative to the server's source of truth.
7. Save the (possibly re-fetched) result to cache with its checksum (Fix B,
   already wired), apply again via `LocalizationManager.applyDynamicTranslations`
   — the eventual-consistency refresh layered on top of the instant cache-first
   paint from step 2.
8. **Failure** (network/server error, not a checksum mismatch) → leave
   whatever's already applied (cache from step 2, or bundled fallback if no
   cache existed) in place. The bloc-level soft error from Fix A is unchanged.

## Testing plan

Written failing first, per the pattern used for Fix A/B:

- **Parser tests** (new file, `settings_remote_datasource` currently has none):
  full-mode response, delta-mode response (`mode`/`changes`/`deleted_keys`/`version`/`checksum`
  all correctly extracted), and a legacy/malformed shape falling back safely.
- **Merge helper tests**: full replace, delta merge + delete-keys, delta with
  no prior cache.
- **`FetchTranslationUseCase`**: a case where `item.mode == 'delta'` but the
  response's own `mode == 'full'` (the delta-unavailable fallback) — asserts
  the response is trusted over the a-priori classification.
- **`GetDynamicLocalizationUseCase`**:
  - cached JSON is applied before the network call resolves (observable via a
    delayed/completer-controlled mock so ordering is verifiable, not just
    end-state).
  - delta response correctly merges onto the cache-first-applied base.
  - checksum mismatch on the merged result triggers cache deletion + one full
    refetch.
  - 304 does not re-apply/re-save (still true, behavior unchanged).

## Out of scope

- Any change to `FetchTranslationUseCase`'s existing checksum-mismatch-refetch
  shape beyond feeding it correctly parsed content — that logic already exists
  and is not being redesigned.
- The `loadBundledFallback` stale package-list issue noted during the earlier
  Fix A/B session (unrelated, previously flagged as low-priority and deferred).
- Any backend/API change — this is entirely client-side parsing and sequencing.
