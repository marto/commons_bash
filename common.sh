#!/bin/bash
# Common logging for bash

if [ -z "$COMMON_SH_SOURCED" ]; then
  COMMON_SH_SOURCED="Parsing common.sh"

  load_scriplet() {
    source "$1" || error "Failed to load '$1'"
  }

  # shellcheck source=common_log.sh
  load_scriplet "$(dirname "${BASH_SOURCE[0]}")/common_log.sh"

fi
# syntax=sh vim: ts=2 sw=2 sts=2 expandtab hlsearch sr
