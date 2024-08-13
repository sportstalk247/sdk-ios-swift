Pod::Spec.new do |spec|

  spec.name         = "SportsTalk247"
  spec.version      = "1.8.4"
  spec.summary      = "The Sportstalk SDK is a helpful wrapper around the Sportstalk API"

  spec.description  = "This Sportstalk SDK is meant to power custom chat applications.  Sportstalk does not enforce any restricitons on your UI design, but instead empowers your developers to focus on the user experience without worrying about the underlying chat behavior."

  spec.homepage     = "https://github.com/sportstalk247/sdk-ios-swift"

  #spec.license     = "MIT (example)"
  # spec.license    = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "Brenn Hill" => "help@sportstalk247.com" }

  spec.platform     = :ios, "10.0"

  spec.source       = { :git => "https://github.com/sportstalk247/sdk-ios-swift.git" }

  spec.source_files  = "SportsTalk247/SportsTalk247/**/*.{swift}"
  spec.resource_bundles  = {'SportsTalk247' => ['SportsTalk247/SportsTalk247/PrivacyInfo.xcprivacy']}
  #spec.exclude_files = "Classes/Exclude"

end
