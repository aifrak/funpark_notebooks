#!/bin/bash

printf "%s\n" "-- Starting devbox shell --"

# Add "--shims" when it is not interactive mode
# see: https://mise.jdx.dev/cli/activate.html
[[ $1 == "--interactive" ]] && shims_flag="--shims" || shims_flag=""

# Initializes mise in the current shell session
eval "$(mise activate $shims_flag $current_shell)"
