#!/bin/bash

printf "%s\n" "-- Starting devbox services --"

(
  current_shell=$(basename "$SHELL")

  eval "$(mise activate --shims $current_shell)"
  # This needs to be run in mise interactive mode,
  # so it can start services just after "devbox shell"

  devbox services restart
)
