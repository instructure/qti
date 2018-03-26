lib = File.expand_path('../lib', __FILE__)
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

  s.add_dependency 'activesupport', '>= 4.2.9', '< 5.2'
  s.add_dependency 'dry-struct', '~> 0.2.1'
  s.add_dependency 'dry-types', '~> 0.12.0'
  s.add_dependency 'rubyzip', '~> 1.2'
  s.add_dependency 'nokogiri', '>= 1.6.8', '< 1.9'
  s.add_dependency 'sanitize', '>= 4.2.0', '< 5.0'
  s.add_dependency 'actionview', '>= 4.2.0'
  s.add_dependency 'mathml2latex', '>= 0.1.0'

  s.add_development_dependency 'bundler', '~> 1.15'
  s.add_development_dependency 'byebug', '~> 9.0'
  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'rspec-mocks', '~> 3.6'
  s.add_development_dependency 'pry', '~> 0'
  s.add_development_dependency 'rubocop', '~> 0.50.0'
  s.add_development_dependency 'simplecov', '~> 0'
  s.add_development_dependency 'wwtd', '~> 1.3'
end
