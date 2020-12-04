#
# Be sure to run `pod lib lint LLDark.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LLDark'
  s.version          = '0.1.0'
  s.summary          = 'A powerful dark theme framework for iOS, designed to quickly adapt to dark mode.'
  s.homepage         = 'https://github.com/internetWei/llDark'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'internetwei' => 'internetwei@foxmail.com' }
  s.source           = { :git => 'https://github.com/internetWei/llDark.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  
  s.source_files = 'Classes/*.{h, m}'
end
