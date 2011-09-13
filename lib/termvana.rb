require 'termvana/version'
require 'termvana/application'

require 'thin'


module Termvana
  def self.start(port = 5432)
    filename = File.expand_path(File.dirname(__FILE__) + '/termvana/config.ru')
    puts "Opening up tervana..."
    Thin::Runner.new("--max-persistent-conns 1024 --timeout 0 -R #{filename} -p #{port} start -e #{Termvana::Application.env}".split).run!
  end
end
