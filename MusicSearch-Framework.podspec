Pod::Spec.new do |s|
s.name             = 'MusicSearch-Framework'
s.version          = '0.1.0'
s.summary          = 'Itunes Music search based on search term framework'

s.description      = <<-DESC
Itunes Music search based on search term framework
DESC

s.homepage         = 'https://github.com/gaurangjogi/MusicSearchFramework'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Gaurang Jogi' => 'gaurang.jogi@photoninfotech.net' }
s.source           = { :git => 'https://github.com/gaurangjogi/MusicSearchFramework.git', :tag => s.version.to_s }

s.ios.deployment_target = '10.0'
s.source_files = 'FantasticView/FantasticView.swift'

end
