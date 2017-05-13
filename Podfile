# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'feds' do

use_frameworks!



source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
pod 'Alamofire', '~> 4.0'
pod 'AlamofireObjectMapper', '~> 4.0'
pod 'AlamofireImage', '~> 3.1'

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

pod 'Eureka', '~> 2.0.0-beta.1'
pod "PromiseKit", "~> 4.0"
pod "PromiseKit/CoreLocation"
pod "PromiseKit/UIKit", "~> 4.0"

# progress indicators
pod "KRProgressHUD"

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

pod 'GoogleMaps'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
