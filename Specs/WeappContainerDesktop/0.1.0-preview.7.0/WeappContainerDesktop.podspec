Pod::Spec.new do |s|
  s.name = 'WeappContainerDesktop'
  s.version = '0.1.0-preview.7.0'
  s.summary = 'Weapp Container native desktop SDK'
  s.homepage = 'https://github.com/weapp-container/sdk-desktop'
  s.author = 'Weapp Container contributors'
  s.license = { :type => 'Apache-2.0', :file => 'share/weapp-container/LICENSE' }
  s.source = { :http => 'https://github.com/weapp-container/sdk-desktop/releases/download/v0.1.0-preview.7.0/WeappContainerDesktop-0.1.0-preview.7.0-macos-universal.tar.gz', :sha256 => '83bf03028a05e1622a825aa3c6e0d3a55d819518d758225010f1830bfa5d27df' }
  s.platform = :osx, '12.0'
  s.vendored_libraries = 'lib/libweapp_container_desktop.a', 'lib/libweapp_container_sdk.a'
  s.preserve_paths = 'include/**/*', 'share/**/*'
  s.libraries = 'c++', 'z', 'iconv', 'resolv'
  s.frameworks = 'AppKit', 'Metal', 'QuartzCore', 'CoreGraphics', 'CoreText', 'CoreFoundation', 'Foundation', 'IOSurface', 'Security', 'SystemConfiguration', 'IOKit', 'AVFoundation', 'CoreMedia', 'CoreVideo', 'CoreLocation', 'CoreWLAN', 'CoreImage', 'CoreBluetooth', 'Contacts', 'EventKit', 'LocalAuthentication'
  s.pod_target_xcconfig = { 'HEADER_SEARCH_PATHS' => '"$(PODS_TARGET_SRCROOT)/include"', 'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17' }
end
