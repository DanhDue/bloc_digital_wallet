Pod::Spec.new do |s|
  s.name             = '{{name.snakeCase()}}'
  s.version          = '0.0.1'
  s.summary          = '{{name.pascalCase()}} native plugin for Super App.'
  s.description      = <<-DESC
{{name.pascalCase()}} native plugin.
                       DESC
  s.homepage         = 'https://github.com/danhdue'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'DanhDue ExOICTIF' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
