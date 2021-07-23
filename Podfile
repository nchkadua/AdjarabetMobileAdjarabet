platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

def pods
  pod 'R.swift'

  pod 'SharedFramework'
  
  pod 'RxSwift'
  pod 'RxCocoa'
  
  pod 'Nuke', '8.4.1'
  pod 'SDWebImageSVGCoder'

  pod 'SwiftLint', '0.39.1'
  pod 'Telegraph'
  pod 'ZIPFoundation'
  
  pod 'Firebase/Core'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Firebase/Performance'
  pod 'FSCalendar'
  pod 'UAParserSwift'
  pod 'SwiftKeychainWrapper'
  pod 'EMPageViewController'
  pod 'IQKeyboardManagerSwift'
end

target 'Mobile' do
  pods
  
  target 'MobileTests' do
    inherit! :search_paths
    pods
  end
end

post_install do |pi|
  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
