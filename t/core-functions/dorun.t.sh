source lib/core-functions.sh || exit 1

echo "====[ dorun test ]===="

function softspot() {
  [[ ${cmdname} == 'softspot' ]] || die "FAIL: cmdname is not softspot"
  einfo "Command name is ${cmdname}, FULL_COMMAND=${FULL_COMMAND}"
}

function deepspot() {
  [[ ${cmdname} == 'deepspot' ]] || die "FAIL: cmdname is not deepspot"
  einfo "Command name is ${cmdname}, FULL_COMMAND=${FULL_COMMAND}"
  dorun softspot
  einfo "Command name is ${cmdname}, FULL_COMMAND=${FULL_COMMAND}"
}

(
  dorun softspot
)
(
  dorun deepspot
)
