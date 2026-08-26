Pod::Spec.new do |s|
  s.name             = 'logger_native_bridge'
  s.version          = '0.0.1'
  s.summary          = 'Headless native-to-Dart logging bridge.'
  s.description      = <<-DESC
Lets plain Kotlin/Swift code (no FlutterEngine attached) push logs to
native telemetry appenders and queues them for best-effort replay into
D3NexusLogger/Talker the next time the Flutter engine attaches.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'

  s.dependency 'Flutter'

  s.platform = :ios, '11.0'
  # static_framework ensures symbols are compiled into the main executable
  s.static_framework = true

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
  }
  s.swift_version = '5.0'
end
