Pod::Spec.new do |s|
    s.name             = "KwaiSDK"
    s.version          = "3.7.3"
    s.summary          = "Kwai Open SDK"
    s.homepage         = "https://github.com/KwaiSocial/KwaiSDK-iOS"
    s.author           = { "gaomingbo" => "gaomingbo@kuaishou.com" }
    s.license          = { :type => "MIT" }
    s.source           = { :git => "https://github.com/KwaiSocial/KwaiSDK-iOS.git", :tag => s.version.to_s }
    s.source_files = "libKwaiSDK/Headers/**/*.h"
    s.vendored_libraries = "libKwaiSDK/ios/*.a"
    s.ios.deployment_target = "12.0"
    s.static_framework = true
    s.frameworks = "WebKit"
    s.pod_target_xcconfig = { "EXCLUDED_ARCHS[sdk=iphonesimulator*]" => "arm64" }
    s.user_target_xcconfig = { "EXCLUDED_ARCHS[sdk=iphonesimulator*]" => "arm64" }   
end
