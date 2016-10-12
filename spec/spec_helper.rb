require 'bundler/setup'
Bundler.setup

require 'qti'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
end
