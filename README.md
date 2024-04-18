# [commons_bash](https://github.com/marto/commons_bash)
Common Bash Scripts &amp; Functions

Some common support scripting functions for unix bash scripting that I'm just fed up with rewriting all the time.

Example : (my_script.sh) 

```
#!/bin/bash
source ${HOME}/bin/lib/common.sh

log_error This is an error log level message
log_warn  This is an warn log level message
log_info  This is an info log level message
log_debug This is an debug log level message

log_info "All of these messages are written to logs/{scriptname}_{hostname}_{current date}.log"

fail_on_error "Fail script and exit with 1 if last command failed"

fail "Ok I'm failing and bailing out"

echo "I can never get here!"
```

# Local Dev Env Install
We use [pre-commit](https://pre-commit.com/) to install pre-commit hooks to this repository and you should follow these instruction when making any changes to this repository:

1. Follow [pre-commit](https://pre-commit.com/) on how to install pre-commit if you don't already have it installed. For the impatient...
  * If using brew use `brew install pre-commit` is the simplest way.
  * If on linux use `pip install pre-commit` then quit/reload your shell.
2. After cloning this repository run `pre-commit install`.
