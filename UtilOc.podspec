Pod::Spec.new do |s|
  s.name                = 'UtilOc'
  s.version             = '1.3.0'
  s.summary             = 'Objective-C Util'
  s.homepage            = 'https://4what.cn'
  s.license             = { :type => 'MIT', :file => 'LICENSE' }
  s.author              = { '4what' => 'root@4what.cn' }
  s.source              = { :git => 'https://github.com/4what/UtilOc.git', :tag => s.version.to_s }

  s.platform            = :ios, '9.0'

  s.source_files        = 'classes/**/*.{h,m}'
  s.public_header_files = 'classes/**/*.h'
end
