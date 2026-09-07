#!/usr/bin/env python3
"""Idempotently set up dev/stg/prd build variants for the iOS Runner project.

Replaces the non-idempotent update_project.py + update_project_runner_tests.py.
Safe to re-run: pbxproj objects are keyed by deterministic ids and skipped if
present; the xcconfig files are regenerated from the secureFiles JSON each run.

For each (mode, flavor) in {Debug,Release,Profile} x {dev,stg,prd}:
  pbxproj:
    * Flutter/<Mode>-<flavor>.xcconfig  PBXFileReference (+ child of the Flutter group)
    * PBXProject  XCBuildConfiguration "<Mode>-<flavor>"  (cloned from "<Mode>")
    * Runner      XCBuildConfiguration "<Mode>-<flavor>"  (cloned; base cfg -> the xcconfig)
    * RunnerTests XCBuildConfiguration "<Mode>-<flavor>"  (cloned from "<Mode>")
    * one entry in each of the 3 XCConfigurationLists
    * a "Copy GoogleService-Info.plist" shell-script build phase on the Runner target
  ios/Flutter/<Mode>-<flavor>.xcconfig:
    * includes Generated.xcconfig + the matching Pods-Runner xcconfig
    * PRODUCT_BUNDLE_IDENTIFIER  = <base id><APP_ID_SUFFIX>   (Info.plist CFBundleIdentifier)
    * DART_DEFINES_APP_NAME      = <APP_NAME>                 (Info.plist CFBundleDisplayName)
      both mirrored from secureFiles/<flavor>/environment-configs.json. Values are
      static per flavor, so there is no build-time extraction / timing race, and the
      full bundle id is always a non-empty resolved build setting (matters for prd,
      whose suffix is empty - an empty $(VAR) is dropped by `xcodebuild -showBuildSettings`).

Assumes a stock Flutter project.pbxproj (objectVersion 54). Run from the repo root:
    python3 ios/scripts/setup_ios_flavors.py [path/to/project.pbxproj]
"""
from __future__ import annotations

import hashlib
import json
import pathlib
import re
import sys

FLAVORS = ["dev", "stg", "prd"]
MODES = ["Debug", "Release", "Profile"]

# Well-known object ids from the stock Flutter iOS template (objectVersion 54).
PROJECT_LIST = "97C146E91CF9000F007C117D"   # XCConfigurationList for PBXProject "Runner"
RUNNER_LIST = "97C147051CF9000F007C117D"    # XCConfigurationList for PBXNativeTarget "Runner"
TESTS_LIST = "331C8087294A63A400263BE5"     # XCConfigurationList for PBXNativeTarget "RunnerTests"
RUNNER_TARGET = "97C146ED1CF9000F007C117D"
FLUTTER_GROUP = "9740EEB11CF90186004384FC"
RESOURCES_PHASE = "97C146EC1CF9000F007C117D"  # Runner "Resources" build phase (insert copy phase after it)

# mode -> (project cfg id, runner cfg id, runnertests cfg id)
BASE = {
    "Debug": ("97C147031CF9000F007C117D", "97C147061CF9000F007C117D", "331C8088294A63A400263BE5"),
    "Release": ("97C147041CF9000F007C117D", "97C147071CF9000F007C117D", "331C8089294A63A400263BE5"),
    "Profile": ("249021D3217E4FDB00AE95B9", "249021D4217E4FDB00AE95B9", "331C808A294A63A400263BE5"),
}

GOOGLE_SERVICE_PHASE_KEY = "phase-copy-google-service-info"


def oid(key: str) -> str:
    return hashlib.md5(f"zeno-flavors::{key}".encode()).hexdigest()[:24].upper()


def extract_block(content: str, obj_id: str) -> str:
    """Return the full "<id> ... = { ... };" object text (brace-matched)."""
    m = re.search(r"^\t\t" + re.escape(obj_id) + r"(?: /\* .*? \*/)? = \{", content, re.M)
    if not m:
        raise RuntimeError(f"object {obj_id} not found")
    start = m.start()
    i = content.index("{", start)
    depth = 0
    for j in range(i, len(content)):
        c = content[j]
        if c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0:
                end = j + 1
                if content[end : end + 1] == ";":
                    end += 1
                return content[start:end]
    raise RuntimeError(f"unbalanced braces for {obj_id}")


def clone_config(
    block: str, new_id: str, new_name: str, base_ref: str | None, bundle_id: str | None = None
) -> str:
    """Clone an XCBuildConfiguration block with a new id/name and optional base xcconfig.

    `bundle_id`, when given, replaces PRODUCT_BUNDLE_IDENTIFIER in buildSettings - this
    must live in the pbxproj (not an xcconfig), because target buildSettings override
    an xcconfig-supplied value.
    """
    # header:  \t\t<oldid> /* Mode */ = {
    block = re.sub(
        r"^\t\t[0-9A-F]{24}(?: /\* .*? \*/)? = \{",
        f'\t\t{new_id} /* {new_name} */ = {{',
        block,
        count=1,
    )
    # trailing name line:  \t\t\tname = Mode;   (may be quoted already)
    block = re.sub(r'\n\t\t\tname = "?[^;\n]+"?;\n\t\t\};\Z', f'\n\t\t\tname = "{new_name}";\n\t\t}};', block)

    ref_line = f"\t\t\tbaseConfigurationReference = {base_ref} /* {new_name}.xcconfig */;\n"
    has_ref = re.search(r"\n\t\t\tbaseConfigurationReference = [^\n]+\n", block)
    if base_ref:
        if has_ref:
            block = re.sub(r"\n\t\t\tbaseConfigurationReference = [^\n]+\n", "\n" + ref_line, block, count=1)
        else:
            block = block.replace("\n\t\t\tisa = XCBuildConfiguration;\n", "\n\t\t\tisa = XCBuildConfiguration;\n" + ref_line, 1)
    elif has_ref:
        block = re.sub(r"\n\t\t\tbaseConfigurationReference = [^\n]+\n", "\n", block, count=1)
    if bundle_id:
        block = re.sub(
            r"(\n\t+PRODUCT_BUNDLE_IDENTIFIER = )[^;\n]+;", rf"\g<1>{bundle_id};", block, count=1
        )
    return block


def load_flavor_config(repo_root: pathlib.Path) -> dict[str, dict]:
    """Read secureFiles/<flavor>/environment-configs.json for each flavor (may be absent)."""
    out: dict[str, dict] = {}
    for flavor in FLAVORS:
        p = repo_root / "secureFiles" / flavor / "environment-configs.json"
        if p.exists():
            out[flavor] = json.loads(p.read_text())
        else:
            print(f"  ! {p} missing - {flavor} identity left at defaults")
    return out


def write_xcconfigs(repo_root: pathlib.Path, flavor_cfg: dict[str, dict]) -> None:
    """(Re)generate ios/Flutter/<Mode>-<flavor>.xcconfig (CFBundleDisplayName source)."""
    flutter_dir = repo_root / "ios" / "Flutter"
    for flavor, cfg in flavor_cfg.items():
        app_name = cfg["APP_NAME"]
        for mode in MODES:
            lc = mode.lower()
            (flutter_dir / f"{mode}-{flavor}.xcconfig").write_text(
                f'#include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.{lc}-{flavor}.xcconfig"\n'
                f'#include "Generated.xcconfig"\n'
                f"\n"
                f"// CFBundleDisplayName for the '{flavor}' flavor - mirrored from\n"
                f"// secureFiles/{flavor}/environment-configs.json.\n"
                f"// Regenerate: python3 ios/scripts/setup_ios_flavors.py\n"
                f"DART_DEFINES_APP_NAME = {app_name}\n"
            )


def insert_after(content: str, anchor: str, text: str) -> str:
    idx = content.index(anchor)
    return content[: idx + len(anchor)] + text + content[idx + len(anchor) :]


def add_to_list(content: str, list_id: str, entries: list[tuple[str, str]]) -> str:
    block = extract_block(content, list_id)
    new_block = block
    for cid, name in entries:
        if cid in new_block:
            continue
        new_block = new_block.replace(
            "\t\t\tbuildConfigurations = (\n",
            f"\t\t\tbuildConfigurations = (\n\t\t\t\t{cid} /* {name} */,\n",
            1,
        )
    return content.replace(block, new_block, 1)


def main() -> int:
    path = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "ios/Runner.xcodeproj/project.pbxproj")
    content = path.read_text()
    original = content
    repo_root = path.resolve().parents[2]  # <root>/ios/Runner.xcodeproj/project.pbxproj

    flavor_cfg = load_flavor_config(repo_root)
    base_bid = re.search(
        r"PRODUCT_BUNDLE_IDENTIFIER = ([^;\n]+);", extract_block(content, BASE["Debug"][1])
    ).group(1).strip().strip('"')

    file_refs, group_children = [], []
    proj_cfgs, runner_cfgs, tests_cfgs = [], [], []
    proj_list_entries, runner_list_entries, tests_list_entries = [], [], []

    base_blocks = {
        m: (
            extract_block(content, BASE[m][0]),
            extract_block(content, BASE[m][1]),
            extract_block(content, BASE[m][2]),
        )
        for m in MODES
    }

    for flavor in FLAVORS:
        for mode in MODES:
            name = f"{mode}-{flavor}"
            xcc = f"{name}.xcconfig"
            fref_id = oid(f"fileref-{name}")
            proj_id = oid(f"cfg-project-{name}")
            runner_id = oid(f"cfg-runner-{name}")
            tests_id = oid(f"cfg-tests-{name}")

            if fref_id not in content:
                file_refs.append(
                    f'\t\t{fref_id} /* {xcc} */ = {{isa = PBXFileReference; '
                    f'lastKnownFileType = text.xcconfig; name = "{xcc}"; '
                    f'path = "Flutter/{xcc}"; sourceTree = "<group>"; }};\n'
                )
                group_children.append(f"\t\t\t\t{fref_id} /* {xcc} */,\n")

            pblk, rblk, tblk = base_blocks[mode]
            bid = None
            if flavor in flavor_cfg:
                bid = base_bid + flavor_cfg[flavor].get("APP_ID_SUFFIX", "")
            if proj_id not in content:
                proj_cfgs.append("\n" + clone_config(pblk, proj_id, name, None))
                proj_list_entries.append((proj_id, name))
            if runner_id not in content:
                runner_cfgs.append("\n" + clone_config(rblk, runner_id, name, fref_id, bid))
                runner_list_entries.append((runner_id, name))
            if tests_id not in content:
                tests_cfgs.append("\n" + clone_config(tblk, tests_id, name, None))
                tests_list_entries.append((tests_id, name))

    if file_refs:
        content = insert_after(content, "/* Begin PBXFileReference section */\n", "".join(file_refs))
    if group_children:
        gblk = extract_block(content, FLUTTER_GROUP)
        nblk = gblk.replace("\t\t\tchildren = (\n", "\t\t\tchildren = (\n" + "".join(group_children), 1)
        content = content.replace(gblk, nblk, 1)

    new_cfgs = "".join(proj_cfgs + runner_cfgs + tests_cfgs)
    if new_cfgs:
        content = insert_after(content, "/* End XCBuildConfiguration section */", "")  # ensure marker exists
        marker = "/* End XCBuildConfiguration section */"
        idx = content.index(marker)
        content = content[:idx] + new_cfgs + "\n" + content[idx:]

    content = add_to_list(content, PROJECT_LIST, proj_list_entries)
    content = add_to_list(content, RUNNER_LIST, runner_list_entries)
    content = add_to_list(content, TESTS_LIST, tests_list_entries)

    # "Copy GoogleService-Info.plist" build phase on the Runner target
    gid = oid(GOOGLE_SERVICE_PHASE_KEY)
    if gid not in content:
        phase = (
            f"\t\t{gid} /* Copy GoogleService-Info.plist */ = {{\n"
            f"\t\t\tisa = PBXShellScriptBuildPhase;\n"
            f"\t\t\talwaysOutOfDate = 1;\n"
            f"\t\t\tbuildActionMask = 2147483647;\n"
            f"\t\t\tfiles = (\n\t\t\t);\n"
            f"\t\t\tinputPaths = (\n\t\t\t);\n"
            f'\t\t\tname = "Copy GoogleService-Info.plist";\n'
            f"\t\t\toutputPaths = (\n\t\t\t);\n"
            f"\t\t\trunOnlyForDeploymentPostprocessing = 0;\n"
            f"\t\t\tshellPath = /bin/sh;\n"
            f'\t\t\tshellScript = "\\"${{SRCROOT}}/scripts/copy_google_service_plist.sh\\"\\n";\n'
            f"\t\t}};\n"
        )
        content = insert_after(content, "/* Begin PBXShellScriptBuildPhase section */\n", phase)
        tgt = extract_block(content, RUNNER_TARGET)
        ntgt = tgt.replace(
            f"\t\t\t\t{RESOURCES_PHASE} /* Resources */,\n",
            f"\t\t\t\t{RESOURCES_PHASE} /* Resources */,\n\t\t\t\t{gid} /* Copy GoogleService-Info.plist */,\n",
            1,
        )
        content = content.replace(tgt, ntgt, 1)

    if content != original:
        path.write_text(content)
        print(f"updated {path}")
    else:
        print(f"{path}: no changes (already set up)")

    write_xcconfigs(repo_root, flavor_cfg)
    print("regenerated ios/Flutter/<Mode>-<flavor>.xcconfig")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
