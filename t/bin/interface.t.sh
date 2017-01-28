source lib/core-functions.sh

echo "==== [ bin/gentoo-perl ] ===="
bash bin/gentoo-perl

echo "==== [ bin/gentoo-perl help ] ===="
bash bin/gentoo-perl help

echo "==== [ bin/gentoo-perl help help ] ===="
bash bin/gentoo-perl help help

echo "==== [ bin/gentoo-perl help x-does-not-exist ] ===="
bash bin/gentoo-perl help x-does-not-exist

echo "==== [ bin/gentoo-perl x-does-not-exist ] ===="
bash bin/gentoo-perl x-does-not-exist



