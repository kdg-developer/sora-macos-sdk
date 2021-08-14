Pod::Spec.new do |s|
  s.name         = "Sora"
  s.version      = "2021.1.2"
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
  s.resources = ['Sora/info.json']
  s.prepare_command = 'sh Sora/info.sh'
  s.dependency "WebRTC", '92.4515.9.1.2'
  s.dependency "Starscream", "3.1.1"
  s.pod_target_xcconfig = {
    'ARCHS' => 'arm64',
    'ARCHS[config=Debug]' => '$(ARCHS_STANDARD)'
  }
end
