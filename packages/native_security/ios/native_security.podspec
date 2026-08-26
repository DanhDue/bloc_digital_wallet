Pod::Spec.new do |s|
  s.name             = 'native_security'
  s.version          = '0.0.1'
  s.summary          = 'A reusable native security module.'
  s.description      = <<-DESC
A reusable native security module using Dart FFI for secure key storage.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  
  s.platform = :ios, '11.0'
  # static_framework ensures symbols are compiled into the main executable
  s.static_framework = true
  s.dependency 'Flutter'
  # DatadogNativeAppender.swift (Task 7) registers itself against
  # logger_native_bridge's D3NexusNativeLogger.
  s.dependency 'logger_native_bridge'

  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'GCC_SYMBOLS_PRIVATE_EXTERN' => 'NO'
  }
  s.swift_version = '5.0'
end
