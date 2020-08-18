# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Cauldron' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!

  pod 'BEMCheckBox'
  pod 'IQKeyboardManagerSwift', '6.0.4'
  pod 'AFNetworking', '~> 3.0'
  pod 'LGSideMenuController'
  pod 'SkyFloatingLabelTextField', '~> 2.0.0'
  pod 'IQDropDownTextField'
  pod 'SHMultipleSelect', '~> 0.2.2'
  pod 'MZAppearance'
  pod 'MGSwipeTableCell'
  pod 'MZFormSheetPresentationController'
  pod 'SVProgressHUD'
  pod 'Toast-Swift'
  pod 'LetterAvatarKit'
  pod 'HMSegmentedControl'
  pod 'Toast', '~> 4.0.0'
  pod 'Charts'
  
  # Pods for Cauldron

  target 'CauldronTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
