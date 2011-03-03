# Copyright:: 2011 triAGENS GmbH
# Author:: Oliver Kiessler (mailto:kiessler@inceedo.com)
require 'rubygems'
gem 'httparty'
require 'httparty'
gem 'json'
require 'json'
require 'uri'
require 'logger'
require 'yaml'

require File.dirname(__FILE__) + '/simplevoc/open/configuration.rb'
require File.dirname(__FILE__) + '/simplevoc/open/base.rb'
require File.dirname(__FILE__) + '/simplevoc/open/client.rb'
require File.dirname(__FILE__) + '/simplevoc/open/exceptions.rb'
require File.dirname(__FILE__) + '/simplevoc/open/hash.rb'
