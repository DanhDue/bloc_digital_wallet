#!/usr/bin/env bash
# Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
set -euo pipefail

# Convenience wrapper for pac_rename_project mason brick
if [[ $# -eq 3 && "$1" != --* ]]; then
  exec mason make pac_rename_project --app_name "$1" --package_name "$2" --bundle_id "$3" --on-conflict overwrite
elif [[ $# -eq 2 && "$1" != --* ]]; then
  exec mason make pac_rename_project --package_name "$1" --bundle_id "$2" --on-conflict overwrite
else
  exec mason make pac_rename_project "$@"
fi
