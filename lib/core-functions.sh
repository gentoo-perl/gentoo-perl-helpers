# die message
function die() {
  FULL_COMMAND=${FULL_COMMAND:-$(basename $0)}
  echo -n -e "\e[31;1m * [${FULL_COMMAND}] \e[0m" >&2
  echo "$@" >&2
  exit 1
}

# eerror message
function eerror() {
  FULL_COMMAND=${FULL_COMMAND:-$(basename $0)}
  echo -n -e "\e[31;1m * [${FULL_COMMAND}] \e[0m" >&2
  echo "$@" >&2
}

# einfo message
function einfo() {
  FULL_COMMAND=${FULL_COMMAND:-$(basename $0)}
  echo -n -e "\e[32m * [${FULL_COMMAND}] \e[0m" >&2
  echo "$@"                   >&2
}

# ewarn message
function ewarn() {
  FULL_COMMAND=${FULL_COMMAND:-$(basename $0)}
  echo -n -e "\e[33m * [${FULL_COMMAND}] \e[0m" >&2
  echo "$@"                   >&2
}

# require_bin bin_name portage/package
function require_bin() {
  type "$1" >/dev/null || die "No $1 in path, install $2"
}

# dorun cmd @args
function dorun() {
  local cmd="$1"
  local cmdname="$(basename "$cmd")"
  shift
  cmdname="${cmdname}" FULL_COMMAND="${FULL_COMMAND} > $cmdname" "$cmd" "$@"
}

# Initial values for these variables is the same, but they can diverge
export FULL_COMMAND="${FULL_COMMAND:-$(basename $0)}"
cmdname="${cmdname:-$(basename $0)}"
