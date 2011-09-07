# -*- encoding: utf-8 -*-
require 'rubygems' unless Object.const_defined?(:Gem)
require File.dirname(__FILE__) + "/lib/termvana/version"
 
Gem::Specification.new do |s|
  s.name        = "termvana"
  s.version     = Termvana::VERSION
  s.authors     = ["David Haslem"]
  s.email       = "therabidbanana@gmail.com"
  s.homepage    = "http://github.com/therabidbanana/termvana"
  s.summary = "A ruby web shell that is very ape and very nice and stuff"
  s.description =  "A ruby web shell that has autocompletion and readline behavior. It uses websockets, repl.js, readline.js and ripl for the shell engine."
  s.required_rubygems_version = ">= 1.3.6"
  # s.rubyforge_project = 'tagaholic'
  s.require_paths = ['lib']
  s.executables  = ['termvana', 'termvana-websocket']
  s.add_dependency 'ripl', '>= 0.3.0'
  s.add_dependency 'pidly', '~> 0.1.3'
  s.add_dependency 'launchy', '~> 2.0.5'
  s.add_dependency 'escape_utils', '>= 0.1.8'
  s.add_dependency 'json_pure', '>= 1.4.3'
  s.add_dependency 'em-websocket', '>= 0.1.4'
  s.files = Dir.glob(%w[{lib,test}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile termvana.gemspec}
  s.files += Dir.glob('lib/**/*.{css,html,js,gif}')
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
  s.license = 'MIT'
end
