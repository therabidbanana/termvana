require 'cramp'
require 'thin'
require 'bundler'
require 'http_router'
require 'async-rack'
require 'virtus'
require 'active_support/json'

module Termvana
  class Application

    def self.root(path = nil)
      @_root ||= File.expand_path(File.dirname(__FILE__))
      path ? File.join(@_root, path.to_s) : @_root
    end

    def self.env
      @_env ||= (ENV['RACK_ENV'] || 'development')
    end

    def self.routes
      @_routes ||= eval(File.read("#{root}/config/routes.rb"))
    end

    # Initialize the application
    def self.initialize!
    end

  end
end

# Preload application classes
Dir["#{File.expand_path(File.dirname(__FILE__))}/app/models/*.rb"].each {|f| require f}
Dir["#{File.expand_path(File.dirname(__FILE__))}/app/command_processor.rb"].each {|f| require f}
Dir["#{File.expand_path(File.dirname(__FILE__))}/app/**/*.rb"].each {|f| require f}

