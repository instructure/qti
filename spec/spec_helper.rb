require 'byebug'

# Limit coverage reporting to one build:
if /^2\.6/ =~ RUBY_VERSION && /rails-6\.0/ =~ ENV['BUNDLE_GEMFILE']
  require 'simplecov'

  SimpleCov.start do
    add_filter 'lib/qti/version.rb'
    add_filter 'spec'
    track_files 'lib/**/*.rb'
  end

  SimpleCov.minimum_coverage(90)
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'qti'

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
end
