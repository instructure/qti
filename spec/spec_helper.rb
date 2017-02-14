require 'bundler/setup'
require 'byebug'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
end

require 'qti'
