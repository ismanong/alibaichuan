#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'alibaichuan'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

#  s.source = { :git => "http://repo.baichuan-ios.taobao.com/baichuanSDK/AliBCSpecs.git", :tag => s.version.to_s }
#  s.dependency 'AlibcTradeSDK'
#  s.dependency 'AliBCSpecs', :git => 'http://repo.baichuan-ios.taobao.com/baichuanSDK/AliBCSpecs.git'

#  s.static_framework = true

  s.vendored_frameworks ="ALiTradeSDK_3.1.1.206_full_package/Frameworks/*.framework"
  s.resource = "ALiTradeSDK_3.1.1.206_full_package/Resources/*.bundle"
  s.frameworks = "MobileCoreServices","AssetsLibrary","CoreMotion","ImageIO","CoreData","CoreLocation","Security","SystemConfiguration","CoreTelephony","CFNetwork","CoreGraphics","UIKit","Foundation"
  s.libraries = "z","stdc++","sqlite3.0"
  #,"-lstdc++"
  s.ios.deployment_target = '8.0'
end

