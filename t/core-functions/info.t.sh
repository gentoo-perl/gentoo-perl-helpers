source lib/core-functions.sh || exit 1

echo "====[ eerror test ]===="

eerror "This is an error"

FULL_COMMAND="test" eerror "This is an error"

FULL_COMMAND="test" dorun eerror "this is an error"

dorun eerror "this is an error"

echo "====[ einfo test ]===="

einfo "This is info"

FULL_COMMAND="test" einfo "This is info"

FULL_COMMAND="test" dorun einfo "this is info"

dorun einfo "this is info"

echo "====[ ewarn test ]===="

ewarn "This is warn"

FULL_COMMAND="test" ewarn "This is warn"

FULL_COMMAND="test" dorun ewarn "this is warn"

dorun ewarn "this is warn"


