source lib/core-functions.sh

echo "==== [ bin/gentoo-perl print-matching-abi 5.24 ] ===="
bash bin/gentoo-perl print-matching-abi 5.24
echo

echo "==== [ bin/gentoo-perl print-matching-abi 5.22 ] ===="
bash bin/gentoo-perl print-matching-abi 5.22
echo

echo "==== [ bin/gentoo-perl print-matching-abi 5.20 ] ===="
bash bin/gentoo-perl print-matching-abi 5.20
echo

echo "==== [ bin/gentoo-perl print-matching-abi 5.21 ] ===="
bash bin/gentoo-perl print-matching-abi 5.21 && die "FAIL: Expected INVALID ABI Fails"
echo
