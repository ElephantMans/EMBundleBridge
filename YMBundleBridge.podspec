#
# Be sure to run `pod lib lint YMBundleBridge.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YMBundleBridge'
  s.version          = '0.1.2'
  s.summary          = 'iOS App组件间通信模块'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  iOS App组件间通信模块，支持URL页面,Target-Action模式调用和事件总线模式
                       DESC
                    
  s.homepage         = 'https://github.com/ElephantMans/EMBundleBridge'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ElephantMans' => 'xiangping165@sina.com' }
  s.source           = { :git => 'https://github.com/ElephantMans/EMBundleBridge.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'YMBundleBridge/Classes/**/*'
  s.static_framework = true

  # s.resource_bundles = {
  #   'YMBundleBridge' => ['YMBundleBridge/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
#  s.dependency 'QTEventBus'
#  s.dependency 'QTEventBus/AppModule'
#  s.dependency 'QTEventBus/UIKit'

s.pod_target_xcconfig = {
  "HEADER_SEARCH_PATHS" => "${PODS_ROOT}/**",
}
end
