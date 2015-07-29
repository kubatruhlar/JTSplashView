Pod::Spec.new do |s|
  s.name         = "JTSplashView"
  s.version      = "1.0.0"
  s.summary      = "Create the beautiful splash view with **JTSplashView**."

  s.description  = <<-DESC
                   Create the beautiful splash view with **JTSplashView** and customize it.
                   DESC

  s.homepage     = "https://github.com/kubatru/JTSplashView"
  s.screenshots  = "https://raw.githubusercontent.com/kubatru/JTSplashView/master/Screens/example1.png"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author    = "Jakub Truhlar"
  s.social_media_url   = "http://kubatruhlar.cz"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/kubatru/JTSplashView.git", :tag => "1.0.0" }
  s.source_files  = "JTSplashView/*"
  s.framework  = "UIKit"
  s.requires_arc = true
end
