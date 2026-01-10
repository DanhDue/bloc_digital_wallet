#!/bin/bash
set -e

# Source shared ignore patterns
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/addlicense_ignore_patterns.sh"

# Add license header to all files
eval "addlicense -f header_template.txt $ADDLICENSE_IGNORE_PATTERNS ."
