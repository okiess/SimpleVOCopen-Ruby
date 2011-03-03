require 'rubygems'
require 'bundler'
require './lib/simplevoc-open.rb'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "simplevoc-open"
  gem.homepage = "http://www.worldofvoc.com/products/simplevoc/summary/"
  gem.license = "Apache License Version 2.0, January 2004"
  gem.summary = "A pure in-memory key/value store with a REST interface"
  gem.description = "Easy installation, easy administration and simple to use is the focus of the SimpleVOC. It is a pure in-memory key/value store with a REST interface. Unlike other key/value stores the SimpleVOC provides a prefix search!"
  gem.email = "kiessler@inceedo.com"
  gem.authors = ["triAGENS GmbH", "Oliver Kiessler"]
  gem.add_dependency "httparty", ">= 0.7.4"
  gem.add_dependency "json", ">= 1.4.6"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.rcov_opts = %w{--exclude osx\/objc,gems\/,spec\/}
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "SimpleVOC Open Ruby Client #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
