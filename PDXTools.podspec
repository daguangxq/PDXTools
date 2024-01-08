Pod::Spec.new do |spec|
    spec.name = 'PDXTools'
    spec.version = '1.0.1'
    spec.license = 'MIT'
    spec.summary = 'PDX 一些常用工具类，有问题咨询daguangxq@icloud.com'
    spec.homepage = 'https://github.com/daguangxq/PDXTools'
    spec.authors = { 'pdx' => 'daguangxq@icloud.com' }
    spec.source = { :git => 'https://github.com/daguangxq/PDXTools.git', :tag => spec.version }
    spec.platform     = :ios, '13.0'
    
    # 常用核心功能
    spec.subspec 'Core' do |subspec|
        subspec.name = 'Core'
        subspec.source_files = 'PDXTools/Classes/Core/**/*.swift'
        #subspec.public_header_files = 'PDXTools/Classes/Core/**/*.swift'
        subspec.dependency 'QMUIKit'
        subspec.dependency 'Kingfisher'
    end
    
    # 第三方登陆
    spec.subspec 'ThirdLogin' do |subspec|
        subspec.name = 'ThirdLogin'
        subspec.dependency 'WechatOpenSDK-XCFramework', '~> 2.0.2'
        subspec.dependency 'GoogleSignIn', '~> 7.0.0'
        subspec.dependency 'FacebookLogin', '~> 0.9.0'
        subspec.source_files = 'PDXTools/Classes/ThirdLogin/*.swift'
    end
    
    spec.default_subspec = 'Core'
end
