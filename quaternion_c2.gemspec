lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "quaternion_c2"
  spec.version       = "0.9.0"
  spec.authors       = ["Masahiro Nomoto"]
  spec.email         = ["hmmnrst@users.noreply.github.com"]

  spec.summary       = %q{Quaternion class}
  spec.description   = %q{Provides a numeric class Quaternion which is similar to a built-in class Complex.}
  spec.homepage      = "https://github.com/hmmnrst/quaternion_c2"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
end
