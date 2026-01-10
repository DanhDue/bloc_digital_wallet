#!/bin/bash
set -e

# Source shared ignore patterns
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/addlicense_ignore_patterns.sh"

# Check license header in all files (includes test exclusion)
eval "addlicense -f header_template.txt --check $ADDLICENSE_IGNORE_PATTERNS_WITH_TEST ."
