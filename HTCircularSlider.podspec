Pod::Spec.new do |s|
  s.name         = "HTCircularSlider"
<<<<<<< HEAD
  s.version      = "0.0.2"
=======
  s.version      = "0.0.3"
>>>>>>> release/0.0.3
  s.summary      = "CircularSlider with UIImage handle"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage     = "https://github.com/hayatan/HTCircularSlider"
  s.author       = { "hayatan" => "hayatan.dev@gmail.com" }
<<<<<<< HEAD
  s.source       = { :git => "https://github.com/hayatan/HTCircularSlider.git", :tag => "v#{s.version}" }
=======
  s.source       = { :git => "https://github.com/hayatan/HTCircularSlider.git", :tag => "#{s.version}"}
>>>>>>> release/0.0.3
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'HTCircularSlider/Sources/*.{h,m}'
  s.resources    = 'HTCircularSlider/Sources/*.png'
end
