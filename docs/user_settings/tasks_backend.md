# Backend Tasks: Dynamic Configuration & User Preferences Sync

This document outlines the main tasks that the Backend (BE) team needs to implement to support the Dynamic Configuration, User Preferences Sync, and Delta Versioning features.

> **Related Documents**:
> - [Dynamic Configuration HLD](./dynamic_configuration_hld.md)
> - [Dynamic Configuration API](./dynamic_configuration_api.md)
> - [User Preferences Sync API](./user_preferences_sync_api.md)

---

## 1. Django App & ORM Models Setup
- [ ] Create a new Django App: `python manage.py startapp user_settings` (and add it to `INSTALLED_APPS` in `zeno/settings.py`).
- [ ] Define `Translation` and `Theme` models in `user_settings/models.py` using `models.Model` and `JSONField` for storing the JSON tree.
- [ ] Define `AppConfig` model for singleton configurations (like active campaign).
- [ ] Define `UserPreference` model with a `ForeignKey` to the `User` model, `Translation`, and `Theme`.
- [ ] Define `ConfigChangeLog` model for Delta Versioning, with indexes on `resource_type`, `resource_id`, and `version` for fast lookup and pruning.
- [ ] Run `python manage.py makemigrations user_settings` and `python manage.py migrate`.

## 2. Configuration Management APIs (Admin)
- [ ] Create Pydantic schemas in `user_settings/schemas.py` for Translation and Theme admin payloads (e.g., `TranslationIn`, `ThemeIn`, `ConfigOut`).
- [ ] Create a Ninja Router in `user_settings/api.py`: `admin_router = Router(tags=["Admin Config"])`.
- [ ] Implement `@admin_router.post("/translations")` (Create translation).
- [ ] Implement `@admin_router.get("/translations")` (List all translations).
- [ ] Implement `@admin_router.get("/translations/{language_code}")` (Get translation details).
- [ ] Implement `@admin_router.patch("/translations/{language_code}")` (Update with deep merge).
- [ ] Implement `@admin_router.delete("/translations/{language_code}")` (Delete/Deactivate translation).
- [ ] Implement corresponding CRUD endpoints for Themes on `@admin_router`.
- [ ] Implement `@admin_router.put("/themes/active-campaign")` (Set/clear campaign theme).
- [ ] Register `admin_router` in the main NinjaAPI instance in `zeno/api.py`.
- [ ] **Validation Layer**: Use Ninja's dependency injection or signal pre-delete hooks to prevent deletion of default language/theme.
- [ ] **Backward Compatibility**: Add business rules or warnings to prevent Admin from deleting keys that are actively used by supported app versions.

## 3. Delta Versioning Logic & Data Integrity
- [ ] On every `PATCH` request in the admin router, automatically increment the `version` string in the ORM instance.
- [ ] Record a changelog entry using `ConfigChangeLog.objects.create(...)` detailing `changes` and `deleted_keys` as `JSONField`.
- [ ] **Checksum Generation**: Calculate MD5 or SHA-256 hash of the full updated JSON tree and save it to the ORM model's `checksum` field.
- [ ] Implement delta aggregation logic in a service layer (e.g., `services/config_service.py`): when a client requests data with `?since_version=X`, fetch all `ConfigChangeLog` rows `from_version > X`, merge them using Python dictionary merging, and return.
- [ ] **Smart Fallback**: If `ConfigChangeLog.objects.filter(...)` indicates the version gap is too large (e.g., > 50 versions), automatically skip merging and return `mode: "full"`.
- [ ] Implement a Django Management Command (`python manage.py prune_config_deltas`) or a Celery beat task to delete old `ConfigChangeLog` rows (e.g., >30 days old or keeping only the last 20 versions).

## 4. Client APIs & Sync
- [ ] Create a Ninja Router for Client APIs: `client_router = Router(tags=["Client Sync"])`.
- [ ] Define schemas in `user_settings/schemas.py` for client requests (e.g., `BootstrapRequest`) and responses (e.g., `DeltaResponseSchema`).
- [ ] Implement `@client_router.get("/translations")` (List available languages for client).
- [ ] Implement `@client_router.get("/translations/{language_code}")` with `since_version` Query param and `If-None-Match` Header support. Include `checksum`.
- [ ] Implement `@client_router.get("/themes")` (List available themes for client).
- [ ] Implement `@client_router.get("/themes/{theme_id}")` with `since_version` Query param. Include `checksum`.
- [ ] Implement `@client_router.post("/sync/bootstrap")`. Must calculate stale resources using ORM queries and return `user_preferences`.
- [ ] **Guest User Support**: Ensure `POST /sync/bootstrap` uses `auth=None` in Django Ninja or gracefully handles missing auth tokens to return `null` for `user_preferences`.

## 5. User Preferences APIs
- [ ] Use Django Ninja's `@router.get("/users/me/preferences", auth=api_auth)` to retrieve preferences.
- [ ] Use `@router.put("/users/me/preferences", auth=api_auth)` for idempotent upsert of user preferences.

## 6. Push Notifications
- [ ] Integrate with FCM/APNS to send silent push notifications on configuration mutation (after Admin `PATCH` operations).
- [ ] Ensure push payload contains `type`, `resource`, `resource_id`, and `new_version`.
