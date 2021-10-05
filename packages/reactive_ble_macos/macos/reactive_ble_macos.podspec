#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint reactive_ble_mobile.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'reactive_ble_macos'
  s.version          = '0.0.1'
  s.summary          = 'Bluetooth Low Energy (BLE) Flutter plug-in for macOS.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/PhilipsHue/flutter_reactive_ble'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Protobuf', '~> 3.5'
  s.dependency 'SwiftProtobuf', '~> 1.0'
  s.dependency 'FlutterMacOS'
  s.osx.deployment_target = '10.13'
  s.platform = :osx, '10.13'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1' }
  s.swift_version       = '4.2'
end

