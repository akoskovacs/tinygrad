# frozen_string_literal: true

require_relative 'lib/tinygrad/version'

Gem::Specification.new do |spec|
  spec.name = 'tinygrad'
  spec.version = TinyGrad::VERSION
  spec.authors = ['Ákos Kovács']
  spec.email = ['akoskovacs0@gmail.com']

  spec.summary = 'Tiny Autograd engine for Ruby based on micrograd'
  spec.description = "A blatant copy of Andrej Karpathy's micrograd Autograd engine, with a PyTorch-like API"
  spec.homepage = 'https://github.com/akoskovacs/tinygrad'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/akoskovacs/tinygrad'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'ruby-graphviz', '>= 1.2'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
