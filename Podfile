platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

def pods
	pod 'EMPageViewController'
	pod 'Firebase/Analytics'  
	pod 'Firebase/Core'
	pod 'Firebase/Crashlytics'
	pod 'Firebase/Performance'
	pod 'FSCalendar'
	pod 'IQKeyboardManagerSwift'
	pod 'Nuke', '8.4.1'
	pod 'R.swift'
	pod 'ReachabilitySwift'
	pod 'RxCocoa'
	pod 'RxSwift'
	pod 'SDWebImageSVGCoder'
	pod 'SharedFramework'
	pod 'SwiftKeychainWrapper'
	pod 'SwiftLint', '0.39.1'
	pod 'Telegraph'
	pod 'UAParserSwift'
	pod 'ZIPFoundation'
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
