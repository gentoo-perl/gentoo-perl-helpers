#!/bin/bash
(
bash t/cmd/installed-perl-virtuals.t.sh
bash t/cmd/installed-perl-core.t.sh
bash t/cmd/installed-deps-perl-subslot-rebuild.t.sh
bash t/cmd/gen-upgrade-sets.t.sh
bash t/cmd/installed-deps-atom.t.sh
) |& tee t/runtest-volatile.out
echo "------// DIFF //------------------"
sed -i 's|[^ ]*/gentoo-perl-helper[.]test[.]gen-upgrade-sets[.][^/]*/|TEMPDIR/|' t/runtest-volatile.out
diff -Naur t/runtest-volatile.expected t/runtest-volatile.out
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
mv t/runtest-volatile.out t/runtest-volatile.expected
