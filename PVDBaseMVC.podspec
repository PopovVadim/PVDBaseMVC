#
# Be sure to run `pod lib lint PVDBaseMVC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PVDBaseMVC'
  s.version          = '0.2.0'
  s.summary          = 'A set of base Models, ViewControllers, Views and other UI to use or inherit from'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A set of base Models, ViewControllers, Views and other UI to use or inherit from. Uses imperative UI creation approach (no storyboards)
                       DESC

  s.homepage         = 'https://github.com/PopovVadim/PVDBaseMVC'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PopovVadim' => 'podh2o@gmail.com' }
  s.source           = { :git => 'https://github.com/PopovVadim/PVDBaseMVC.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'PVDBaseMVC/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PVDBaseMVC' => ['PVDBaseMVC/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
    s.dependency 'PVDSwiftAddOns', '~> 0.2.0'
    s.dependency 'SnapKit', '~> 4.0.0'
    s.dependency 'SDWebImage', '~> 4.3'
end
