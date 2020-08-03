Pod::Spec.new do |s|
    s.name             = "KwaiSDK"
    s.version          = "3.4.5"
    s.summary          = "Kwai Open SDK"
    s.homepage         = "https://github.com/KwaiSocial/KwaiSDK-iOS"
    s.author           = { "gaomingbo" => "gaomingbo@kuaishou.com" }
    s.license          = { :type => "MIT" }
    s.source           = { :git => "https://github.com/KwaiSocial/KwaiSDK-iOS.git", :tag => s.version.to_s }
    s.vendored_frameworks = "KwaiSDKLibrary/KwaiSDK.framework"
    s.ios.deployment_target = "8.0"
    s.resource_bundles = {"KwaiSDK" => ["KwaiSDK/Resources/**/*"]}
    s.static_framework = true
    s.frameworks = "WebKit"
end
