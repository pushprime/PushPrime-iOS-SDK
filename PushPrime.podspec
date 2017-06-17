#
# Be sure to run `pod lib lint PushPrime.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PushPrime'
  s.version          = '1.0.0'
  s.summary          = 'PushPrime Official SDK for iOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
PushPrime is leading push notifications platform. This SDK makes it simple to integrate Apple Push Notifications Service (APNS) with PushPrime.
                       DESC

  s.homepage         = 'https://github.com/pushprime/PushPrime-iOS-SDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pushprimeguy' => 'support@pushprime.com' }
  s.source           = { :git => 'https://github.com/pushprime/PushPrime-iOS-SDK.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/pushprime'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PushPrime/Classes/**/*'

  # s.resource_bundles = {
  #   'PushPrime' => ['PushPrime/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UserNotifications'
end
