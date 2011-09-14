# Generated by cucumber-sinatra. (2011-09-11 15:02:47 -0400)

ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.require(:test)
require File.join(File.dirname(__FILE__), '..', '..', 'lib/termvana.rb')
require 'capybara'
require 'capybara/cucumber'
require 'rspec'

Capybara.default_host = "http://127.0.0.1"
Capybara.server_port = 6543
Capybara.app_host = "#{Capybara.default_host}:#{Capybara.server_port}"
Thread.new {
  puts "Running server"
  Thin::Logging.silent = true
  Termvana.start(Capybara.server_port)
  puts "server is running"
}
Capybara.run_server = false

# Waiting for server to boot - if we don't let capybara run server,
# we have to manually wait.
sleep 5
Capybara.app = Termvana

Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium

class MyAppWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  MyAppWorld.new
end

