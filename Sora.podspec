Pod::Spec.new do |s|
  s.name         = "Sora"
  s.version      = "2022.1.4"
  s.summary      = "Sora macOS SDK"
  s.homepage     = "https://github.com/soudegesu/sora-macos-sdk"
  s.description  = <<-DESC
                   A library to develop Sora client applications.
                   DESC
  s.license      = { :type => "Apache License, Version 2.0" }
  s.authors      = { "Shiguredo Inc." => "https://shiguredo.jp/", "soudegesu" => "" }
  s.platform     = :osx, "10.15"
  s.source       = {
      :git => "https://github.com/soudegesu/sora-macos-sdk.git",
      :tag => s.version
  }
  s.source_files  = "Sora/**/*.swift"
  s.resources = []
  s.dependency "WebRTC", '101.4951.5.1.1'
  s.pod_target_xcconfig = {
    'ARCHS' => 'arm64 x86_64',
    'ARCHS[config=Debug]' => '$(ARCHS_STANDARD)'
  }
end
