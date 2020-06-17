Pod::Spec.new do |s|

  s.name         = "NIOURLNavigator"
  s.version      = "0.0.1"
  s.summary      = "URL Navigator"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { 'can.chen' => 'can.chen@nio.com' }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/wangteng6680/URLNavigator.git", :tag => "#{s.version}" }
  s.homepage     = "https://github.com/wangteng6680/URLNavigator"
  s.source_files = "*.{h,m}"
  # s.resources    = "Source/*.{png,xib,nib,bundle}"
  s.framework    = "UIKit"
  s.requires_arc = true
end
