# Limit coverage reporting to one build:
if /^2\.5/ =~ RUBY_VERSION && /rails-5\.2/ =~ ENV['BUNDLE_GEMFILE']
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
require 'action_view'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
end

require 'qti'
