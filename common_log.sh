#!/bin/bash
# Common logging for bash

if [ -z "$COMMON_LOG_SH_SOURCED" ]; then
  COMMON_LOG_SH_SOURCED="Parsing common_log.sh"

  # Set DEBUG_LOG to 1 to enable debug output.
  COLOR_GREEN='\e[1;32m'
  COLOR_YELOW='\e[1;33m'
  COLOR_BLUE='\e[1;34m'
  COLOR_RED='\e[0;31m'
  COLOR_GRAY='\e[1;30m'
  COLOR_NC='\e[0m'

  # Set the LOG_FILE location if it hasn't already been set yet and create the log dir location
  if [ -z "$LOG_FILE" ]; then
    export LOG_FILE="$(dirname $0)/logs/$(basename $0 | sed -e 's/\.[^.]*$//')_$(hostname)_$(date +%F).log"
  fi
  if [ ! -d "$(dirname "$LOG_FILE")" ]; then
    echo "Creating log dir '"$(dirname "$LOG_FILE")"'"
    mkdir -p "$(dirname "$LOG_FILE")"
  fi

  log() {
    if [ ! -z "$LOG_FILE" ]; then
      echo "$(date '+%F +%T'): $*" >> "$LOG_FILE"
    fi
    LOG_LEVEL=$1
    case "$LOG_LEVEL" in
      "ERROR") shift 1; echo -e "${COLOR_RED}$(date '+%F +%T') ${LOG_LEVEL}: $*${COLOR_NC}" ;;
      "WARN")  shift 1; echo -e "${COLOR_YELOW}$(date '+%F +%T') ${LOG_LEVEL}: $*${COLOR_NC}" ;;
      "INFO")  shift 1; echo -e "${COLOR_BLUE}$(date '+%F +%T') ${LOG_LEVEL}: $*${COLOR_NC}" ;;
      "DEBUG") shift 1; echo -e "${COLOR_GRAY}$(date '+%F +%T') ${LOG_LEVEL}: $*${COLOR_NC}" ;;
      *) echo "$(date '+%F +%T') ?:$*" ;;
    esac
  }

  log_debug() {
    log DEBUG $*
  }

  log_info() {
    log INFO $*
  }

  log_error() {
    log ERROR $*
  }

  log_warn() {
    log WARN $*
  }

  fail() {
    log_error $*
    echo "$* - Check $LOG_FILE for details" >&2
    exit 1
  }

  fail_on_error() {
    if [ ! $? -eq 0 ]; then
      fail "$*"
    fi
  }

fi
# syntax=sh vim: ts=2 sw=2 sts=2 expandtab hlsearch sr expandtab
