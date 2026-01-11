#!/bin/bash

set -e

# Format all dart files except Mason brick templates (which contain template syntax)
git ls-files -z -- '*.dart' | grep -zv '__brick__' | xargs -0 dart format "$@" -l 99
