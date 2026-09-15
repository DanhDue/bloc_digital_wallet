#!/bin/bash
# Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

set -e

# Usage: ./scripts/add_native_ui.sh <plugin_package_name>
# Example: ./scripts/add_native_ui.sh sensor_kit

PACKAGE_NAME=${1:-}

if [ -z "$PACKAGE_NAME" ]; then
  echo "Usage: ./scripts/add_native_ui.sh <plugin_package_name>"
  echo "Example: ./scripts/add_native_ui.sh sensor_kit"
  exit 1
fi

PACKAGE_DIR="packages/$PACKAGE_NAME"

if [ ! -d "$PACKAGE_DIR" ]; then
  echo "❌ Error: Package '$PACKAGE_DIR' does not exist."
  exit 1
fi

echo "🚀 Upgrading headless package '$PACKAGE_NAME' with native UI..."

mason make pac_add_native_ui --name "$PACKAGE_NAME" --on-conflict overwrite

echo "✅ Successfully added native UI to '$PACKAGE_NAME'."
