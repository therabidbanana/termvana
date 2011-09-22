# A command set is like a Rails engine - it's a plugin that can bundle
# assets and define classes
module Termvana
  class CommandSet

    def self.subclasses
      @subclasses ||= []
    end

    def self.inherited(base)
      subclasses << base
    end

    def self.root(path = nil)
      @_root ||= path if path
      @_root
    end

    def self.commands(*args)
      @_commands ||= []
      @_commands += args
      @_commands
    end

    def self.autoload_asset(path = nil)
      @_autoload_assets ||= []
      @_autoload_assets << path if path
      @_autoload_assets
    end

    def commands
      self.class.commands
    end

    def self.autoload_assets
      @_autoload_assets
    end
    
    def initialize
    end

    def has_assets?
      File.exists?(File.join(self.class.root, 'assets'))
    end

    def add_asset_paths_to(sprockets)
      return unless has_assets?
      %w(javascripts js stylesheets css images img).each do |dir|
        
        sprockets.append_path(File.join(self.class.root, 'assets', dir)) if File.exists?(File.join(self.class.root, 'assets', dir))
      end
      sprockets.append_path(File.join(self.class.root, 'assets'))
    end

  end
end
