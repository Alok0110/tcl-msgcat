# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tcl/msgcat/version'

Gem::Specification.new do |spec|
  spec.name          = "tcl-msgcat"
  spec.version       = Tcl::Msgcat::VERSION
  spec.authors       = ["Robert McLeod"]
  spec.email         = ["robert@autogrow.com"]
  spec.summary       = %q{Library for parsing, rendering and merging TCL msgcat files}
  spec.description   = %q{Library for parsing, rendering and merging TCL msgcat files}
  spec.homepage      = "https://github.com/AutogrowSystems/tcl-msgcat"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "multi_json"
  spec.add_dependency "oj"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
