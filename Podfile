# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

target 'TourismApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for TourismApp
  pod 'SnapKit', '~> 4.0.0'
  pod 'Alamofire'
  pod 'MHLoadingButton'
  pod 'GSKStretchyHeaderView'
  pod ‘googleapis’, :path => ‘.’
  pod 'GoogleMaps', '5.1.0' 
  pod 'GooglePlaces'
  pod 'FloatingPanel'
  pod 'Kingfisher'
  pod 'PanModal'
  pod 'Localize-Swift', '~> 3.2'
	pod 'SwiftyStarRatingView'
  pod 'CameraManager', '~> 5.1'


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
