function red(s) {
  printf "\033[1;31m" s "\033[0m "
}

function green(s) {
  printf "\033[1;32m" s "\033[0m "
}

function blue(s) {
  printf "\033[1;34m" s "\033[0m "
}

function yellow(s) {
  printf "\033[1;33m" s "\033[0m "
}

function now(level) {
  return strftime("%Y-%m-%d %z:%H:%M:%S ") level " >>";
}

BEGIN {
  FS="\n"
}
{
  if (color == "blue") {
    print now("INFO") $0 >> logfile
    print blue(now("INFO")) blue($0)
  } else if (color == "yellow") {
    print now("WARN") $0 >> logfile
    print yellow(now("WARN")) yellow($0)
  } else {
    print now("DEBUG") $0 >> logfile
    print now("DEBUG") $0
  }
}
