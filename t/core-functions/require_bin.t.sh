source lib/core-functions.sh || exit 1

echo "====[ require_bin test ]===="

(
  require_bin "ls" "sys-apps/coreutils" || die "FAIL: Must have ls"
)
(
  (
    require_bin "x-some-program-that-does-not-exist" "sys-fictious/troll-program"
  ) && die "FAIL: require_bin must fail"
)
(
  (
    dorun require_bin "x-some-program-that-does-not-exist" "sys-fictious/troll-program"
  ) && die "FAIL: require_bin must fail"
)
