#!/usr/bin/env bash
# Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
set -euo pipefail

APP_NAME=""
PACKAGE_NAME=""
BUNDLE_ID=""
MODE="enterprise"
DRY_RUN=false
FORCE=false
EXTRA_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      if [[ -z "${2:-}" ]]; then
        echo "Error: --mode requires an argument ('enterprise' or 'lean')." >&2
        exit 1
      fi
      MODE="$2"
      shift 2
      ;;
    --mode=*)
      MODE="${1#*=}"
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --*)
      EXTRA_ARGS+=("$1")
      shift
      ;;
    *)
      if [[ -z "$APP_NAME" ]]; then
        APP_NAME="$1"
      elif [[ -z "$PACKAGE_NAME" ]]; then
        PACKAGE_NAME="$1"
      elif [[ -z "$BUNDLE_ID" ]]; then
        BUNDLE_ID="$1"
      else
        EXTRA_ARGS+=("$1")
      fi
      shift
      ;;
  esac
done

if [[ "$MODE" != "enterprise" && "$MODE" != "lean" ]]; then
  echo "Error: Unsupported mode '$MODE'. Choose 'enterprise' or 'lean'." >&2
  exit 1
fi

if [[ "$DRY_RUN" == true ]]; then
  echo "Dry run: mode: $MODE, app_name: $APP_NAME, package_name: $PACKAGE_NAME, bundle_id: $BUNDLE_ID"
  exit 0
fi

MASON_ARGS=(
  make pac_rename_project
  --on-conflict overwrite
  --mode "$MODE"
)

if [[ -n "$APP_NAME" ]]; then
  MASON_ARGS+=(--app_name "$APP_NAME")
fi
if [[ -n "$PACKAGE_NAME" ]]; then
  MASON_ARGS+=(--package_name "$PACKAGE_NAME")
fi
if [[ -n "$BUNDLE_ID" ]]; then
  MASON_ARGS+=(--bundle_id "$BUNDLE_ID")
fi
if [[ "$FORCE" == true ]]; then
  MASON_ARGS+=(--force)
fi

exec mason "${MASON_ARGS[@]}" "${EXTRA_ARGS[@]}"
