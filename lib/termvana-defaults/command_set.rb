class TermvanaDefaultCommandSet < Termvana::CommandSet
  # Set the root path so that assets can be found
  root File.expand_path(File.dirname(__FILE__))

  # Declare a javascript file to be autoloaded by the autoload_plugins()
  # sprockets helper.
  autoload_asset "termvana-defaults/test.js"
end
