Pod::Spec.new do |s|
  s.name = 'HueKit'
  s.version = '1.0.1'
  s.license = 'MIT'
  s.summary = 'PDX 一些常用工具类，有问题咨询daguangxq@icloud.com'
  s.homepage = 'https://github.com/daguangxq/PDXTools'
  s.authors = { 'pdx' => 'daguangxq@icloud.com' }
  s.source = { :git => 'https://github.com/daguangxq/PDXTools.git', :tag => s.version }
  s.platform     = :ios, '13.0'
  s.requires_arc = false
  s.source_files = 'PDXTools/Core/**/*.swift'
end
