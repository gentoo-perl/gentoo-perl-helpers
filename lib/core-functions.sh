if [[ -z "${LIBDIR:-}" ]]; then
  export LIBDIR="@@LIBDIR@@"
  export LIBEXECDIR="@@LIBEXECDIR@@"

  if [[ ${LIBDIR:0:2} == "@@" ]]; then
    export LIBDIR="$PWD/lib"
    export LIBEXECDIR="$PWD/libexec"
  fi
fi

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
  [[ ${GENTOO_PERL_HELPERS_QUIETNESS:-0} -gt 4 ]] && return;
  _wrap_trace "32m" >&2
  echo "$@"         >&2
}

# ewarn message
function ewarn() {
  [[ ${GENTOO_PERL_HELPERS_QUIETNESS:-0} -gt 9 ]] && return;
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
  local fullcommand="${LIBEXECDIR%/}/${cmd}"
  local cmdname="$(basename "$cmd")"
  shift

  if [[ ! -e "${fullcommand}" ]]; then
    if type "${cmd}" >/dev/null ; then
      cmdname="${cmdname}" FULL_COMMAND="${FULL_COMMAND} > $cmdname" "$cmd" "$@" || return $?
    else
      die "No such command ${cmd}, ${fullcommand} does not exist";
    fi
  else if [[ ! -x "${fullcommand}" ]]; then
    die "${fullcommand} is not executable";
    fi
    cmdname="${cmdname}" FULL_COMMAND="${FULL_COMMAND} > $cmdname" "$fullcommand" "$@" || return $?
  fi
}

# Initial values for these variables is the same, but they can diverge
export FULL_COMMAND="${FULL_COMMAND:-$(basename $0)}"
cmdname="${cmdname:-$(basename $0)}"
