# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'JSDDUPDT' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for JSDDUPDT

  target 'JSDDUPDTTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'JSDDUPDTUITests' do
    # Pods for testing
  end

  post_install do |installer|
  installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
  config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
  end
  end
  end
 

 pod 'LifevitSDK', :branch => "2.1.0", :git => "https://github.com/lifevit/ios-sdk.git"
 pod 'webrtcat4', :git => 'https://github.com/seg-i2CAT/webrtcat4_ios.git', :branch => '4.0.0'
 pod 'IHKeyboardAvoiding', '~> 4.6'
# pod 'FSCalendar', '~> 2.8.0'
 pod 'Toast-Swift', '~> 5.0.1'
 pod 'SwiftyTimer', '~> 2.0'
 pod 'Alamofire', '~> 4.0'
 pod 'SwiftyJSON'
 pod 'SDWebImage'
 pod 'DropDown', '2.3.4'
 pod 'Starscream'
 pod 'RxSwift', '~> 4.4.0'
 pod 'Firebase/Core'
 pod 'Firebase/Messaging'
 pod 'CVCalendar', '~> 1.7.0'
 pod 'Firebase/Crashlytics'
 pod 'PopOverMenu'
 pod 'Charts'
end
