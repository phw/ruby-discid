# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'discid/version'

Gem::Specification.new do |spec|
  spec.name          = "discid"
  spec.version       = DiscId::VERSION
  spec.authors       = ["Philipp Wolfer"]
  spec.email         = ["ph.wolfer@gmail.com"]
  spec.description   = %q{Ruby bindings for libdiscid. See http://musicbrainz.org/doc/libdiscid for more information on libdiscid and MusicBrainz.}
  spec.summary       = %q{Ruby bindings for libdiscid}
  spec.homepage      = ""
  spec.license       = "LGPL3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ffi", "~> 1.6.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
