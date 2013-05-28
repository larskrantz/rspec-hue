# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "rspec_hue"
  spec.version       = '0.1.0' 
  spec.authors       = ["Lars Krantz"]
  spec.email         = ["lars.krantz@alaz.se"]
  spec.description   = %q{Light up philips hue when testing}
  spec.summary       = %q{Let Hue indicate if tests are passing or not}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency     "rspec"
  spec.add_runtime_dependency     "huey"
end
