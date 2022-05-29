#!/bin/bash

source $(dirname $0)/common.sh

log_error This is an error log level message
log_warn  This is an warn log level message
log_info  This is an info log level message
log_debug This is an debug log level message

log_info "All of these messages are written to logs/{scriptname}_{hostname}_{current date}.log"
log_info "All of these messages are written to logs/{scriptname}_{hostname}_{current date}.log"

fail_on_error "Fail script and exit with 1 if last command failed"

fail "Ok I'm failing and bailing out"

echo "I can never get here!"
