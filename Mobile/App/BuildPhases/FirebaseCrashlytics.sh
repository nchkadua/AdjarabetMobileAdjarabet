"${PODS_ROOT}/FirebaseCrashlytics/run"

#if [ "$CONFIGURATION" == "Release-Stage" ] || [ "$CONFIGURATION" == "Release-Production" ]
#then
#"${PODS_ROOT}/FirebaseCrashlytics/upload-symbols" -gsp "${PROJECT_DIR}/Mobile/App/Resources/GoogleService-Info.plist" -p ios "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}"
#else
#echo "skip upload-symbols"
#fi


# Upload symbols manually
# PROJECT_NAME/Pods/FirebaseCrashlytics/upload-symbols -gsp GoogleService-Info.plist_path -p ios appDsyms_path
