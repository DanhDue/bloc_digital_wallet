#!/usr/bin/env bash
# Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
set -euo pipefail

MODE=""
PRUNE=false
FORCE=false
ROOT_DIR=""
SKIP_VERIFY=false

for arg in "$@"; do
  case "$arg" in
    enterprise|lean)
      MODE="$arg"
      ;;
    --prune)
      PRUNE=true
      ;;
    --force)
      FORCE=true
      ;;
    --root-dir=*)
      ROOT_DIR="${arg#*=}"
      ;;
    --skip-verify)
      SKIP_VERIFY=true
      ;;
    -h|--help)
      echo "Usage: $0 <enterprise|lean> [--prune] [--force] [--root-dir=<path>] [--skip-verify]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 1
      ;;
  esac
done

if [[ -z "$MODE" ]]; then
  echo "Error: Mode must be specified as 'enterprise' or 'lean'" >&2
  exit 1
fi

if [[ -z "$ROOT_DIR" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

echo "==> Configuring project mode: $MODE (Root: $ROOT_DIR, Prune: $PRUNE, Force: $FORCE)"

# Safety check for uncommitted changes when pruning
if [[ "$MODE" == "lean" && "$PRUNE" == true ]]; then
  if [[ "$FORCE" != true ]]; then
    if git -C "$ROOT_DIR" status --porcelain 2>/dev/null | grep -q .; then
      echo "Working tree has uncommitted changes. Use --force to override." >&2
      exit 1
    fi
  fi
fi

# Execute Python marker toggling engine
python3 - "$ROOT_DIR" "$MODE" "$PRUNE" << 'EOF'
import os
import sys
import re
import shutil

root_dir = os.path.abspath(sys.argv[1])
mode = sys.argv[2]
prune = sys.argv[3].lower() == 'true'

EXTENSIONS = {'.dart', '.yaml', '.yml'}
SKIP_DIRS = {'.git', '.dart_tool', '.fvm', 'build', '.idea', '.vscode'}

begin_re = re.compile(r'^(\s*)(//|#)\s*([a-zA-Z0-9_\-:]+):(begin)\s*$', re.IGNORECASE)
end_re = re.compile(r'^(\s*)(//|#)\s*([a-zA-Z0-9_\-:]+):(end)\s*$', re.IGNORECASE)

def process_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except Exception:
        return

    new_lines = []
    i = 0
    n = len(lines)
    changed = False

    while i < n:
        line = lines[i]
        m_begin = begin_re.match(line)
        if m_begin:
            marker_indent = m_begin.group(1)
            comment_type = m_begin.group(2)
            marker_name = m_begin.group(3)
            new_lines.append(line)
            i += 1

            is_lean_marker = 'lean' in marker_name.lower()
            is_active = is_lean_marker if (mode == 'lean') else (not is_lean_marker)
            comment_prefix = f"{comment_type} "
            prefix_with_space = f"{marker_indent}{comment_prefix}"
            prefix_no_space = f"{marker_indent}{comment_type}"

            block_lines = []
            while i < n:
                inner_line = lines[i]
                m_end = end_re.match(inner_line)
                if m_end and m_end.group(3) == marker_name:
                    for bline in block_lines:
                        nl = '\n' if bline.endswith('\n') else ''
                        line_body = bline[:-1] if bline.endswith('\n') else bline

                        if line_body.strip() == '':
                            new_lines.append(bline)
                            continue

                        if is_active:
                            # Uncomment if line starts with prefix
                            if line_body.startswith(prefix_with_space):
                                rest = line_body[len(prefix_with_space):]
                                new_lines.append(f"{marker_indent}{rest}{nl}")
                                changed = True
                            elif line_body.startswith(prefix_no_space):
                                rest = line_body[len(prefix_no_space):]
                                new_lines.append(f"{marker_indent}{rest}{nl}")
                                changed = True
                            else:
                                new_lines.append(bline)
                        else:
                            # Comment out if not already commented
                            if line_body.startswith(prefix_with_space) or line_body.startswith(prefix_no_space):
                                new_lines.append(bline)
                            else:
                                if line_body.startswith(marker_indent):
                                    rest = line_body[len(marker_indent):]
                                else:
                                    rest = line_body.lstrip()
                                new_lines.append(f"{marker_indent}{comment_prefix}{rest}{nl}")
                                changed = True
                    new_lines.append(inner_line)
                    i += 1
                    break
                else:
                    block_lines.append(inner_line)
                    i += 1
        else:
            new_lines.append(line)
            i += 1

    if changed:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.writelines(new_lines)
        print(f"  Updated markers: {os.path.relpath(filepath, root_dir)}")

# Walk all target files
for root, dirs, files in os.walk(root_dir):
    dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
    for file in files:
        _, ext = os.path.splitext(file)
        if ext in EXTENSIONS:
            process_file(os.path.join(root, file))

# Handle prune operations in lean mode
if mode == 'lean' and prune:
    scanner_dir = os.path.join(root_dir, 'features', 'scanner')
    if os.path.exists(scanner_dir):
        shutil.rmtree(scanner_dir)
        print(f"  Pruned directory: features/scanner")

    root_pubspec = os.path.join(root_dir, 'pubspec.yaml')
    if os.path.exists(root_pubspec):
        with open(root_pubspec, 'r', encoding='utf-8') as f:
            content = f.read()
        new_content = re.sub(r'^\s*-\s*features/scanner\s*$\n', '', content, flags=re.MULTILINE)
        new_content = re.sub(r'(?ms)^\s*#?\s*#?\s*pubspec:scanner-dependency:begin.*?#?\s*#?\s*pubspec:scanner-dependency:end\s*\n?', '', new_content)
        new_content = re.sub(r'(?m)^\s*#?\s*scanner:\s*\n\s*#?\s*path:\s*features/scanner\s*\n', '', new_content)
        if new_content != content:
            with open(root_pubspec, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"  Pruned features/scanner from pubspec.yaml")
EOF

# Verification phase
if [[ "$SKIP_VERIFY" != true ]]; then
  echo "==> Running workspace bootstrap and analysis verification..."
  MELOS_CMD="melos"
  if command -v fvm >/dev/null 2>&1; then
    MELOS_CMD="fvm dart run melos"
  fi

  (cd "$ROOT_DIR" && $MELOS_CMD bootstrap)
  (cd "$ROOT_DIR" && $MELOS_CMD run analyze)
fi

echo "==> Successfully configured mode: $MODE"
