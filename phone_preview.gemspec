require_relative "lib/phone_preview/version"

Gem::Specification.new do |spec|
  spec.name = "phone_preview"
  spec.version = PhonePreview::VERSION
  spec.authors = [ "Tyler Schneider" ]
  spec.email = [ "tylercschneider@gmail.com" ]
  spec.homepage = "https://github.com/DYB-Development/phone_preview"
  spec.summary = "Opens a locally running Rails app on a phone through an ngrok tunnel."
  spec.description = "Starts a Rails app in development with an ngrok tunnel on one port, prints its public address and a QR code of it, and makes emailed links use that address."
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["documentation_uri"] = "#{spec.homepage}#readme"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.required_ruby_version = ">= 3.3.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["lib/**/*", "exe/*", "LICENSE", "README.md", "CHANGELOG.md"]
  end
  spec.bindir = "exe"
  spec.executables = [ "phone_preview" ]

  spec.add_dependency "railties", ">= 7.1"
  spec.add_dependency "rqrcode", "~> 3.0"
end
