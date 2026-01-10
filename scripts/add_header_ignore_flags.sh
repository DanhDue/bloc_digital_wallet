#!/bin/bash
set -e

# Source shared ignore patterns
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/addlicense_ignore_patterns.sh"

# Add header ignore flags with repository-specific patterns and test exclusion
eval "addlicense -f ignore_flags.txt $ADDLICENSE_IGNORE_PATTERNS_WITH_REPOS --ignore 'test/**' ."
