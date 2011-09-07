require 'launchy'
require 'ripl'
require 'ripl/web'
require 'termvana/shell'
require 'termvana/util'
require 'termvana/runner'
require 'termvana/version'
require 'termvana/websocket'

module Termvana
  def self.start
    if Runner::EXIT_OPTIONS.include? ARGV[0]
      Termvana::Runner.run ARGV
    else
      @daemon = Termvana::Websocket.spawn(
        :name => 'termvana',
        :path => '/tmp',
        :verbose => true
      )
      @daemon.start unless @daemon.running?
      html_file = File.expand_path(File.dirname(__FILE__) + '/termvana/public/index.html')
      # RUBY_PLATFORM[/darwin/i]  ? system('open', html_file) : puts(html_file)
      Launchy.open html_file
    end
  end
end
