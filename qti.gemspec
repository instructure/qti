lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qti/version'

Gem::Specification.new do |s|
  s.name          = 'qti'
  s.version       = Qti::VERSION
  s.authors       = ['Hannah Bottalla', 'Robinson Rodríguez']
  s.email         = ['hannah@instructure.com', 'rrodriguez-bd@instructure.com', 'quizzes@instructure.com']
  s.summary       = 'QTI 1.2 and 2.1 import and export models'
  s.homepage      = 'https://github.com/instructure/qti'
  s.license       = 'MIT'

  s.files         = Dir.glob('{lib,spec}/**/*') + %w[README.md Rakefile]
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.4'

  s.add_dependency 'actionview', '>= 5.1.7', '< 6.1'
  s.add_dependency 'activesupport', '>= 5.1.7', '< 6.1'
  s.add_dependency 'dry-struct', '~> 0.4.0'
  s.add_dependency 'dry-types', '~> 0.12.3'
  s.add_dependency 'mathml2latex', '~> 2.0'
  s.add_dependency 'nokogiri', '~> 1.10'
  s.add_dependency 'rubyzip', '~> 2.0'
  s.add_dependency 'sanitize', '~> 5.1'

  s.add_development_dependency 'bundler', '~> 1.17'
  s.add_development_dependency 'byebug', '~> 11.0'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'rspec-mocks', '~> 3.8'
  s.add_development_dependency 'rubocop', '~> 0.74.0'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'wwtd', '~> 1.4'
end
