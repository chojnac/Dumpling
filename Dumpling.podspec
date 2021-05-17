
Pod::Spec.new do |s|
  s.name             = 'Dumpling'
  s.version          = '0.3.0'
  s.summary          = 'Dumpling is a pure Swift customisable and extensible Markdown parser for iOS and macOS.'
  s.homepage         = 'https://github.com/chojnac/Dumpling'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Wojciech Chojnacki' => 'me@chojnac.com' }
  s.source           = { :git => 'https://github.com/chojnac/Dumpling.git', :tag => s.version.to_s }
  
  s.swift_version    = '5.3'
  s.source_files = ['Sources/Dumpling/**/*', 'Sources/ParserCore/**/*']

  s.ios.deployment_target = '9.0'
  s.ios.frameworks = "UIKit"

  s.osx.deployment_target = '10.10'
  s.osx.frameworks = "AppKit"

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = ['Tests/DumplingTests/**/*', 'Tests/ParserCoreTests/**/*']
  end

end
