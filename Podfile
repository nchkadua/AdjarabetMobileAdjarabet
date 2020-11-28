platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

def pods
  pod 'R.swift'

  pod 'SharedFramework'
  
  pod 'RxSwift'
  pod 'RxCocoa'
  
  pod 'Nuke', '8.4.1'

  pod 'SwiftLint', '0.39.1'
  
  pod 'Firebase/Core'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Firebase/Performance'
  pod 'FSCalendar'
  
  pod 'Reveal-SDK', :configurations => ['Debug-Stage', 'Debug-Production']
end

target 'Mobile' do
  pods
  
  target 'MobileTests' do
    inherit! :search_paths
    pods
  end
end
