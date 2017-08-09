#
# Be sure to run `pod lib lint ContentFitScrollView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ContentFitScrollView'
  s.version          = '1.0.4'
  s.summary          = 'Self adjustable Scroll View that tries to fit all content on screen without scrolling.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Self adjustable Scroll View that proportionally reducing provided height constraints constants to fit all content on screen without scrolling.
It takes into account `ContentFitLayoutConstraint`'s `minimumHeight` value.
If it's unable to fit content on screen without scrolling it'll just allow scrolling.
                       DESC

  s.homepage         = 'https://github.com/APUtils/ContentFitScrollView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anton Plebanovich' => 'anton.plebanovich@gmail.com' }
  s.source           = { :git => 'https://github.com/APUtils/ContentFitScrollView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ContentFitScrollView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ContentFitScrollView' => ['ContentFitScrollView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
