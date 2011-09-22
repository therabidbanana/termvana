module Termvana
  module SprocketsHelpers
    def autoload_plugins(type = "js")
      Termvana::Application.command_sets.each do |set|
        set.class.autoload_assets.each do |a|
          require_asset(a) if a.match(/\.#{type}/)
        end
      end
    end
  end
end
