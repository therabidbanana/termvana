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
  s.executables  = ['termvana']
  s.add_dependency 'cramp'
  s.add_dependency 'thin'
  s.add_dependency 'i18n'
  s.add_dependency 'bundler'
  s.add_dependency 'http_router'
  s.add_dependency 'async-rack'
  s.add_dependency 'virtus'
  s.add_dependency 'sprockets'
  s.add_dependency 'coffee-script'
  s.add_dependency 'tilt-jade'
  s.add_dependency 'sass'
  s.add_dependency 'activesupport'
  s.files = Dir.glob(%w[{lib,test}/**/*.rb bin/* [A-Z]*.{txt,rdoc} ext/**/*.{rb,c} **/deps.rip]) + %w{Rakefile termvana.gemspec}
  s.files += Dir.glob('lib/**/*.{css,html,js,gif}')
  s.files += ['lib/termvana/config.ru']
  s.extra_rdoc_files = ["README.rdoc", "LICENSE.txt"]
  s.license = 'MIT'
end
