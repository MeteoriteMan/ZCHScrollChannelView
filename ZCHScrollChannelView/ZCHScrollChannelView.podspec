Pod::Spec.new do |s|
  s.name         = "ZCHScrollChannelView"
  s.version      = "0.0.1"
  s.summary      = "You can Use ZCHScrollChannelView to build channelView"
  s.homepage     = "https://github.com/MeteoriteMan/ZCHScrollChannelView"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.author        = { "张晨晖" => "shdows007@gmail.com" }
  s.platform      = :ios
  s.source        = { :git => "https://github.com/MeteoriteMan/ZCHScrollChannelView.git", :tag => "#{version}" }
  s.source_files  = "ZCHScrollChannelView/ZCHScrollChannelView/ZCHScrollChannelView.{h,m}"
end