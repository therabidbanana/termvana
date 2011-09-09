require 'launchy'
require 'ripl'
require 'ripl/web'
require 'ripl/fresh/commands'
require 'termvana/shell'
require 'termvana/config'
require 'termvana/util'
require 'termvana/runner'
require 'termvana/version'
require 'termvana/websocket'
require 'termvana/application'

require 'thin'


module Termvana
  def self.start
    if Runner::EXIT_OPTIONS.include? ARGV.first
      Termvana::Runner.run ARGV
    else
      # html_file = File.expand_path(File.dirname(__FILE__) + '/termvana/public/index.html')
      # @daemon = Termvana::Websocket.spawn(
      #   :name => 'termvana',
      #   :path => '/tmp',
      #   :verbose => true,
      #   :logger => false
      # )
      filename = File.expand_path(File.dirname(__FILE__) + '/termvana/config.ru')
      puts "Opening up tervana..."
      Thin::Runner.new("--max-persistent-conns 1024 --timeout 0 -V -R #{filename} start".split).run!
      # RUBY_PLATFORM[/darwin/i]  ? system('open', html_file) : puts(html_file)
    end
  end
end
