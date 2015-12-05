# -*- encoding: utf-8 -*-
VERSION = "0.1.0"

Gem::Specification.new do |spec|
  spec.name          = "motion-locman"
  spec.version       = VERSION
  spec.authors       = ["Minku Lee"]
  spec.email         = ["premist@me.com"]
  spec.description   = "Simple location library for Rubymotion"
  spec.summary       = "Simple location library for Rubymotion. Wraps CLLocationManager and more."
  spec.homepage      = "https://github.com/premist/motion-locman"
  spec.license       = "MIT"

  files = []
  files << "README.md"
  files.concat(Dir.glob("lib/**/*.rb"))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 0"
end
