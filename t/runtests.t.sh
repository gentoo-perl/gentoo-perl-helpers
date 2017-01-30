#!/bin/bash
(
bash t/core-functions/die.t.sh
bash t/core-functions/dorun.t.sh
bash t/core-functions/info.t.sh
bash t/core-functions/require_bin.t.sh
bash t/bin/interface.t.sh
bash t/cmd/version.t.sh
bash t/cmd/list-commands.t.sh
bash t/cmd/list-commands-desc.t.sh
bash t/cmd/installed-perl-virtuals.t.sh
bash t/cmd/print-matching-abi.t.sh
bash t/cmd/list-excluded-abis.t.sh
bash t/cmd/installed-perl-core.t.sh
bash t/cmd/installed-deps-perl-subslot-rebuild.t.sh
bash t/cmd/gen-upgrade-sets.t.sh
) |& tee t/runtest.out
echo "------// DIFF //------------------"
sed -i 's|[^ ]*/gentoo-perl-helper[.]test[.]gen-upgrade-sets[.][^/]*/|TEMPDIR/|' t/runtest.out
diff -Naur t/runtest.expected t/runtest.out
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
mv t/runtest.out t/runtest.expected
