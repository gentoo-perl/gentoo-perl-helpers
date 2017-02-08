source lib/core-functions.sh

echo "==== [ bin/gentoo-perl installed-match-atom dev-lang/perl ] ===="
bash bin/gentoo-perl installed-match-atom "dev-lang/perl"
echo

echo "==== [ bin/gentoo-perl installed-match-atom perl-core/* ] ===="
bash bin/gentoo-perl installed-match-atom "perl-core/*"
echo

echo "==== [ bin/gentoo-perl installed-match-atom virtual/perl-* ] ===="
bash bin/gentoo-perl installed-match-atom "virtual/perl-*"
echo

