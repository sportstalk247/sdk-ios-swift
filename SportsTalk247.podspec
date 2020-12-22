Pod::Spec.new do |spec|

  spec.name         = "SportsTalk247"
  spec.version      = "0.0.1"
  spec.summary      = "The Sportstalk SDK is a helpful wrapper around the Sportstalk API"

  spec.description  = "This Sportstalk SDK is meant to power custom chat applications.  Sportstalk does not enforce any restricitons on your UI design, but instead empowers your developers to focus on the user experience without worrying about the underlying chat behavior."

  spec.homepage     = "https://gitlab.com/sportstalk247/sdk-ios-swift"

  #spec.license     = "MIT (example)"
  # spec.license    = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "Brenn Hill" => "help@sportstalk247.com" }

  spec.platform     = :ios, "10.0"

  spec.source       = { :git => "https://gitlab.com/sportstalk247/sdk-ios-swift.git" }

  spec.source_files  = "SportsTalk247/SportsTalk247/**/*.{swift}"
  #spec.exclude_files = "Classes/Exclude"

end