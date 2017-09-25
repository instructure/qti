# Limit coverage reporting to one build:
if /^2\.4/ =~ RUBY_VERSION && /nokogiri-1\.8/ =~ ENV['BUNDLE_GEMFILE']
  require 'simplecov'

  SimpleCov.start do
    add_filter 'lib/qti/version.rb'
    add_filter 'spec'
    track_files 'lib/**/*.rb'
  end

  SimpleCov.minimum_coverage(90)
end

require 'bundler/setup'
require 'byebug'
require 'securerandom'

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
end

require 'qti'
