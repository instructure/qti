# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'qti'
  spec.version       = '0.2.12'
  spec.authors       = ['Hannah Bottalla', 'Robinson Rodríguez']
  spec.email         = ['hannah@instructure.com', 'rrodriguez-bd@instructure.com', 'quizzes@instructure.com']
  spec.summary       = %q(QTI 1.2 and 2.1 import and export models)

  spec.files         = Dir.glob('{lib,spec}/**/*') + %w(README.md Rakefile)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 4.2.6'
  spec.add_dependency 'dry-struct', '~> 0.2.1'
  spec.add_dependency 'rubyzip', '~> 1.2.0'

  spec.add_development_dependency 'bundler', '~>1.11'
  spec.add_development_dependency 'byebug', '~> 9.0.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'nokogiri', '1.6.8'
  spec.add_development_dependency 'sanitize', '~> 4.2.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'simplecov'
end
