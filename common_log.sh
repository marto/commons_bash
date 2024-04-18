#!/bin/bash
# Common logging for bash
# Depends on gawk coreutils (sudo apt-get install moreutils coreutils)
# 1) Sets up $LOG_FILE if not already set
# 2) Creates dir for $LOG_FILE if does not already exist
#
# Call log_debug, log_info, log_warn, log_error or fail in your bash script
# Pipe command output to pipe_log for command stdout and stderror to be added to the LOG_FILE


if [ -z "$COMMON_LOG_SH_SOURCED" ]; then
  COMMON_LOG_SH_SOURCED="Parsing common_log.sh"

  # Set DEBUG_LOG to 1 to enable debug output.
  COLOR_YELOW='\033[1;33m'
  COLOR_BLUE='\033[1;34m'
  COLOR_RED='\033[0;31m'
  COLOR_GRAY='\033[1;30m'
  COLOR_NC='\033[0m'
  GAWK_LOG_SCRIPT="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/color-log.gawk"

  # Set the LOG_DIR location if it hasn't already been set
  if [ -z "$LOG_DIR" ]; then
    LOG_DIR="$(dirname "$(readlink -f "$0")")/logs";
    export LOG_DIR
  fi
  # Set the LOG_FILE location if it hasn't already been set yet and create the log dir location
  if [ -z "$LOG_FILE" ]; then
    LOG_FILE="$LOG_DIR/$(basename "$0" | sed -e 's/\.[^.]*$//')_$(hostname)_$(date +%F).log"
  else
    LOG_FILE="$(readlink -f "$LOG_FILE")"
  fi
  if [ ! -d "$(dirname "$LOG_FILE")" ]; then
    echo "Creating log dir '$(dirname "$LOG_FILE")'"
    mkdir -p "$(dirname "$LOG_FILE")"
  fi

  log() {
    LOGGER=$1
    case "$LOGGER" in
      "ERROR") shift 1; echo -e "${COLOR_RED}$(date   '+%F %z:%H:%M:%S ')${LOGGER} [$(basename "$0")]: $*${COLOR_NC}" ;;
      "WARN")  shift 1; echo -e "${COLOR_YELOW}$(date '+%F %z:%H:%M:%S ')${LOGGER} [$(basename "$0")]: $*${COLOR_NC}" ;;
      "INFO")  shift 1; echo -e "${COLOR_BLUE}$(date  '+%F %z:%H:%M:%S ')${LOGGER} [$(basename "$0")]: $*${COLOR_NC}" ;;
      "DEBUG") shift 1; echo -e "${COLOR_GRAY}$(date  '+%F %z:%H:%M:%S ')${LOGGER} [$(basename "$0")]: $*${COLOR_NC}" ;;
      *) 
        LOGGER="?"; 
        echo "$(date '+%F %z:%H:%M:%S') ? [$(basename "$0")]: $*" ;;
    esac
    if [ -n "$LOG_FILE" ]; then
      echo "$(date '+%F %z:%H:%M:%S') $LOGGER [$(basename "$0")]: $*" >> "$LOG_FILE"
    fi
  }

  pipe_info() {
    #ts '%F %z:%H:%M:%S INFO:: ' | tee -a "$LOG_FILE"
    gawk -v color=blue -v "logfile=$LOG_FILE" -f "$GAWK_LOG_SCRIPT"
  }

  pipe_warn() {
    gawk -v color=yellow -v "logfile=$LOG_FILE" -f "$GAWK_LOG_SCRIPT"
    #ts '%F %z:%H:%M:%S WARN:: ' | tee -a "$LOG_FILE"
  }

  pipe_log() {
    gawk -v "logfile=$LOG_FILE" -f "$GAWK_LOG_SCRIPT"
  }

  log_debug() {
    log DEBUG "$*"
  }

  log_info() {
    log INFO "$*"
  }

  log_error() {
    log ERROR "$*"
  }

  log_warn() {
    log WARN "$*"
  }

  fail() {
    log_error "$*"
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
