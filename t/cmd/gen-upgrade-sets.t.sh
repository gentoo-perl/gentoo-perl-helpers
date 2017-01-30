source lib/core-functions.sh

require_bin mktemp sys-apps/coreutils

tempdir="$(mktemp --tmpdir -d gentoo-perl-helper.test.gen-upgrade-sets.XXXXXXX)"

echo "==== [ bin/gentoo-perl gen-upgrade-sets 5.22 5.24 ] ===="
ETC_PORTAGE="${tempdir}/5.24" bash bin/gentoo-perl gen-upgrade-sets 5.22 5.24
echo

echo "==== [ bin/gentoo-perl gen-upgrade-sets 5.20 5.22 ] ===="
ETC_PORTAGE="${tempdir}/5.22" bash bin/gentoo-perl gen-upgrade-sets 5.20 5.22
echo

echo "==== [ bin/gentoo-perl gen-upgrade-sets 5.18 5.20 ] ===="
ETC_PORTAGE="${tempdir}/5.20" bash bin/gentoo-perl gen-upgrade-sets 5.18 5.20
echo

echo "==== [ bin/gentoo-perl gen-upgrade-sets 5.20 5.21 ] ===="
ETC_PORTAGE="${tempdir}/5.21"  bash bin/gentoo-perl gen-upgrade-sets 5.20 5.21 && die "FAIL: Expected INVALID ABI Fails"
echo
