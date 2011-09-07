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

module Termvana
  def self.start
    if Runner::EXIT_OPTIONS.include? ARGV.first
      Termvana::Runner.run ARGV
    else
      html_file = File.expand_path(File.dirname(__FILE__) + '/termvana/public/index.html')
      @daemon = Termvana::Websocket.spawn(
        :name => 'termvana',
        :path => '/tmp',
        :verbose => true,
        :logger => false
      )
      if @daemon.running? && ARGV.size == 0
        puts "Looks like termvana is already running. Just opening browser..."
        Launchy.open html_file
      elsif ARGV.size == 0
        puts "Opening up tervana..."
        @daemon.start
        Launchy.open html_file
      else
        "Sending #{ARGV.first} to termvana daemon."
        @daemon.send ARGV.shift
      end
      # RUBY_PLATFORM[/darwin/i]  ? system('open', html_file) : puts(html_file)
    end
  end
end
