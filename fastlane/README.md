fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios register_app
```
fastlane ios register_app
```

### ios stage
```
fastlane ios stage
```

### ios production
```
fastlane ios production
```

### ios build_for_appstore
```
fastlane ios build_for_appstore
```
Build for App Store
### ios build_stage_for_appstore
```
fastlane ios build_stage_for_appstore
```
Build stage for App Store
### ios build_procution_for_appstore
```
fastlane ios build_procution_for_appstore
```
Build production for App Store
### ios distribute_stage_to_testflight
```
fastlane ios distribute_stage_to_testflight
```
Distribute stage to testflight
### ios distribute_production_to_testflight
```
fastlane ios distribute_production_to_testflight
```
Distribute production to testflight
### ios ping_slack
```
fastlane ios ping_slack
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
