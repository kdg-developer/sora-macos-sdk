Pod::Spec.new do |s|
  s.name         = "Sora"
  s.version      = "2021.2.1"
  s.summary      = "[Unofficial] Sora macOS SDK"
  s.description  = <<-DESC
                   A library to develop Sora client applications.
                   DESC
  s.license      = { :type => "Apache License, Version 2.0" }
  s.authors      = { "Shiguredo Inc." => "sora@shiguredo.jp", "soudegesu" => "" }
  s.platform     = :osx, "10.15"
  s.homepage     = "https://github.com/soudegesu/sora-macos-sdk"
  s.source       = {
      :git => "https://github.com/soudegesu/sora-macos-sdk.git",
      :tag => s.version
  }
  s.source_files  = "Sora/**/*.swift"
  s.resources = []
  s.dependency "WebRTC", '94.4606.3.3.1'
  s.dependency "Starscream", "4.0.4"
  s.pod_target_xcconfig = {
    'ARCHS' => 'arm64 x86_64',
    'ARCHS[config=Debug]' => '$(ARCHS_STANDARD)'
  }
end
