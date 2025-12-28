#!/bin/bash

printf "%s\n" "-- Initializing mise --"

# `mise run` is experimental.
mise settings set experimental true

MISE_ENV=${MISE_ENV:-local}
MISE_TASK_TIMINGS=1
