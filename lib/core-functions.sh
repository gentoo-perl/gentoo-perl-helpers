function _wrap_trace() {
  FULL_COMMAND=${FULL_COMMAND:-$(basename $0)}
  color=$1
  if [[ ${#FULL_COMMAND} -gt ${TRACELIMIT:-45} ]]; then
    echo -n -e "\e[${color} * [...${FULL_COMMAND:0-(${TRACELIMIT:-45}-3)}] \e[0m"
  else
    echo -n -e "\e[${color} * [${FULL_COMMAND}] \e[0m"
  fi
}

# die message
function die() {
  _wrap_trace "31;1m" >&2
  echo "$@"           >&2
  exit 1
}

# eerror message
function eerror() {
  _wrap_trace "31;1m" >&2
  echo "$@"           >&2
}

# einfo message
function einfo() {
  _wrap_trace "32m" >&2
  echo "$@"         >&2
}

# ewarn message
function ewarn() {
  _wrap_trace "33m" >&2
  echo "$@"         >&2
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
