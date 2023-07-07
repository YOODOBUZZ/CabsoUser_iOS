# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'HSTaxiUserApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
 
  use_frameworks!
    pod 'Alamofire', '~> 4.5'
    pod 'GoogleSignIn'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Socket.IO-Client-Swift', '~> 13.1.0'
    pod 'SidebarOverlay'
    pod 'lottie-ios', '~> 2.5.2'
    pod 'IQKeyboardManagerSwift'
    pod 'Toast-Swift', '~> 3.0.1'
    pod 'Cosmos', '~> 15.0'
    pod 'NVActivityIndicatorView'
#    pod 'AccountKit'
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'GooglePlacePicker'
    pod 'BraintreeDropIn'
    pod 'Braintree/PayPal'
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'FacebookShare'
    pod 'FirebaseUI/Auth'
    pod 'FirebaseUI/Phone', '~> 8.1.0'
    pod 'PhoneNumberKit', '~> 2.1'
    pod 'GoogleWebRTC'
    pod 'SwiftyJSON'
    pod 'Google-Mobile-Ads-SDK'
# Pods for HSTaxiUserApp

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
end
