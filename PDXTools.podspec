Pod::Spec.new do |spec|
    spec.name = 'PDXTools'
    spec.version = '1.0.1'
    spec.license = 'MIT'
    spec.summary = 'PDX 一些常用工具类，有问题咨询daguangxq@icloud.com'
    spec.homepage = 'https://github.com/daguangxq/PDXTools'
    spec.authors = { 'pdx' => 'daguangxq@icloud.com' }
    spec.source = { :git => 'https://github.com/daguangxq/PDXTools.git', :tag => spec.version }
    spec.platform     = :ios, '13.0'
    spec.source_files = 'PDXTools/Classes/Core/**/*.swift'
  
    spec.subspec 'ThirdLogin' do |subspec|
        subspec.name = 'ThirdLogin'
        #subspec.dependency 'Dependency1'
        subspec.source_files = 'PDXTools/Classes/ThirdLogin/*.swift'
        # 其他配置项
    end
end
