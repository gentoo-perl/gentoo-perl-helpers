source lib/core-functions.sh || exit 1

echo "====[ die test ]===="

(
  die "This is an error"
  echo "This shouldn't be printed"
)

(
  FULL_COMMAND="test" die "This is an error"
  echo "This shouldn't be printed"
)

(
  FULL_COMMAND="test" dorun die "this is an error"
  echo "This shouldn't be printed"
)

(
  dorun die "this is an error"
  echo "This shouldn't be printed"
)
