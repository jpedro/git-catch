$LOAD_PATH.unshift File.expand_path("../lib", File.realpath(__FILE__))
require "git/catch/version"

Gem::Specification.new do |spec|
  spec.name          = "git-catch"
  spec.version       = Git::Catch::VERSION
  spec.authors       = ["Pedro Barbosa"]
  spec.email         = ["jpedro.barbosa@gmail.com"]

  spec.summary       = %q{Hooks up your git hooks}
  spec.description   = "Hooks up your git hooks."
  spec.homepage      = "https://github.com/jpedro/git-catch"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.4"
  spec.add_development_dependency "bundler", "~> 2.6"
  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "minitest", "~> 5.0"
end
