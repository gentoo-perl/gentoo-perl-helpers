source lib/core-functions.sh

echo "==== [ bin/gentoo-perl list-excluded-abis 5.24 ] ===="
bash bin/gentoo-perl list-excluded-abis 5.24
echo

echo "==== [ bin/gentoo-perl list-excluded-abis 5.22 ] ===="
bash bin/gentoo-perl list-excluded-abis 5.22
echo

echo "==== [ bin/gentoo-perl list-excluded-abis 5.20 ] ===="
bash bin/gentoo-perl list-excluded-abis 5.20
echo

echo "==== [ bin/gentoo-perl list-excluded-abis 5.21 ] ===="
bash bin/gentoo-perl list-excluded-abis 5.21 && die "FAIL: Expected INVALID ABI Fails"
echo
