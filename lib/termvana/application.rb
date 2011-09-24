require 'cramp'
require 'thin'
require 'bundler'
require 'http_router'
require 'async-rack'
require 'virtus'
require 'sprockets'
require 'coffee_script'
require 'erb'
require "tilt-jade/template"
require "jade_js/source"
require 'active_support/json'
require 'active_support/inflector'
require "#{File.expand_path(File.dirname(__FILE__))}/command_set"
require "#{File.expand_path(File.dirname(__FILE__))}/sprockets_helpers"

module Termvana
  class Application

    def self.root(path = nil)
      @_root ||= File.expand_path(File.dirname(__FILE__))
      path ? File.join(@_root, path.to_s) : @_root
    end

    def self.rack_env
      @_rack_env ||= (ENV['RACK_ENV'] || 'development')
    end

    def self.assets
      @_assets ||= Sprockets::Environment.new(root) 
    end

    def self.routes
      @_routes ||= eval(File.read("#{root}/config/routes.rb"))
    end

    def self.command_sets
      @_command_sets ||= []
    end

    def self.env
      @_env ||= {'HOME' => ENV['HOME']}
    end


    def self.command_sets=(set)
      @_command_sets = set
    end

    # Initialize the application
    def self.initialize!
      assets.prepend_path(File.join(root, 'assets'))
      assets.register_engine '.jade', ::TiltJade::Template
      prefs = File.join(ENV['HOME'], '.termvana')
      require File.join(prefs, 'initializer.rb') if File.exist?(File.join(prefs, 'initializer.rb'))

      self.command_sets = Termvana::CommandSet.subclasses.map(&:new)
      self.command_sets.each do |set|
        set.add_asset_paths_to(assets)
        set.commands.each do |command|
          Termvana::CommandProcessor.register(command.classify.constantize)
        end
      end
      assets.prepend_path(prefs) if File.exist?(prefs)
      assets.context_class.instance_eval do
        include Termvana::SprocketsHelpers
      end
    end

  end
end


module EventMachine
  def self.popen3(*args)
    new_stderr = $stderr.dup
    rd, wr = IO::pipe
    $stderr.reopen wr
    connection = EM.popen(*args)
    $stderr.reopen new_stderr
    EM.attach rd, Popen3StderrHandler, connection
    connection
  end
  
  class Popen3StderrHandler < EventMachine::Connection
    def initialize(connection)
      @connection = connection
    end
    
    def receive_data(data)
      @connection.receive_stderr(data)
    end
  end  
end


# Preload application classes
Dir["#{File.expand_path(File.dirname(__FILE__))}/app/models/*.rb"].each {|f| require f}
Dir["#{File.expand_path(File.dirname(__FILE__))}/app/command_processor.rb"].each {|f| require f}
Dir["#{File.expand_path(File.dirname(__FILE__))}/app/**/*.rb"].each {|f| require f}

