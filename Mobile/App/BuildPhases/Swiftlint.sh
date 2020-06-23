#"${PODS_ROOT}/SwiftLint/swiftlint"

if [ "$CONFIGURATION" == "Release-Stage" ] || [ "$CONFIGURATION" == "Release-Production" ]
then
echo "swiftlint was not executed"
else
"${PODS_ROOT}/SwiftLint/swiftlint"
echo "swiftlint in action"
fi
