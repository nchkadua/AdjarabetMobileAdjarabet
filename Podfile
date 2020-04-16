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
end

target 'Mobile' do
  pods
  
  target 'MobileTests' do
    inherit! :search_paths
    pods
  end
end
