require 'termvana/version'
require 'termvana/application'
require 'termvana-defaults'

require 'thin'


module Termvana
  def self.start(opts = {})
    filename = File.expand_path(File.dirname(__FILE__) + '/termvana/config.ru')
    puts "Opening up tervana..."
    Thread.new{ sleep 1; `open http://localhost:#{opts[:port]}/`} if opts[:open]
    port = opts[:port]
    
    Thin::Runner.new("--max-persistent-conns 1024 --timeout 0 -R #{filename} -p #{port} start -e #{Termvana::Application.env}".split).run!
  end
end
