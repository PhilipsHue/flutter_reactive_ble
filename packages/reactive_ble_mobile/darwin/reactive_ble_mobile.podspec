Pod::Spec.new do |s|
  s.name             = 'reactive_ble_mobile'
  s.version          = '0.0.1'
  s.summary          = 'Bluetooth Low Energy (BLE) Flutter plug-in'
  s.description      = <<-DESC
Bluetooth Low Energy (BLE) Flutter plug-in
                       DESC
  s.homepage         = 'https://github.com/PhilipsHue/flutter_reactive_ble'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'reactive_ble_mobile/Sources/reactive_ble_mobile/**/*.swift'
  s.dependency 'Protobuf', '~> 3.5'
  s.dependency 'SwiftProtobuf', '~> 1.0'
  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1' }
  s.swift_version       = '4.2'
end

