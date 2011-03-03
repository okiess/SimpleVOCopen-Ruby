SimpleVOC Open REST Client
==========================

This ruby library is a REST client for the SimpleVOC key/value store.

SimpleVOC is a pure in-memory key/value store with a REST Interface. It was developed with easy installation, administration and operation in mind. Checkout [World of Voc](http://www.worldofvoc.com) for more information.


Installation
------------

Tested on Ruby 1.8.7 and RubyGems 1.5.2.

	[sudo] gem install httparty
	[sudo] gem install simplevoc-open


Configuration
-------------

You can setup the client by passing options into the constructor or by using a configuration file in YAML.

    client = Simplevoc::Open::Client.new('host' => 'localhost', 'port' => 12345)

Possible configuration options:

* host (required)
* port (required)
* protocol ("http"/"https"), defaults to "http"
* strict_mode (true/false), defaults to true
* log_level, defaults to LOGGER::INFO

You can also provide a configuration file in the current directory of your client to avoid setting up the client within your code. Checkout the config.yml.sample file as an example.

If this configuration file isn't found in the current directory, the client will look for a "global" configuration file in your home directory (~/.simplevoc.yml).


Usage
-----

Add the "simplevoc" gem to your bundler Gemfile in Rails 3.x or require the simplevoc gem manually.

    gem 'simplevoc-open'
    require 'simplevoc-open'


Examples
--------

Creating the client:

    gem 'simplevoc-open'
    require 'simplevoc-open'
    client = SimplevocOpen::Client.new('host' => 'localhost', 'port' => 12345, 'log_level' => LOGGER::DEBUG)

    key = "foo"; value = "bar"
    key2 = "foo2"; value2 = "bar2"

Inserting a value:

     begin
       client.insert(key, value) # => true/false
     rescue => e
       puts "Inserting fails if the key already exists..."
     end

Inserting a value with extended values (meta information, must be known to the server):

     client.insert(key, value, "{'name':'test'}") => true/false

Or

     client.insert(key2, value2, {'name' => 'test'}) => true/false

To avoid exceptions, create a client in non-strict mode

    client = Simplevoc::Open::Client.new('host' => 'localhost', 'port' => 12345, 'log_level' => LOGGER::DEBUG, 'strict_mode' => false)

Creating or updating a value:

    client.insert_or_update(key, "bar new")
	=> true/false

Updating a value

    success = client.update(key, "bar new") # key must exist, use non-strict mode to avoid exceptions
    => true/false

Getting a value (with additional information)

    client.get(key) # key must exist
	=> {"flags"=>0, "value"=>"value", "created"=>#<DateTime: 17680436009/7200,0,2299161>}
	
Getting the value only

    client.get(key, false) # key must exist
    => "value"

Deleting a value

    success = client.delete(key) # key must exist
	=> true/false

Getting keys by a prefix

    key2 = "foo2"; value2 = "bar2"
    client.insert(key2, value2)
    client.keys("f")
    => ["foo", "foo2"]

Flush all values:

    client.flush
	=> true/false

Using the Simplevoc Hash as a simple non-strict mode alternative:

	hash = Simplevoc::Open::Hash.new('host' => 'localhost', 'port' => 12345) # accepts the same options as the regular client

	key = "foo"; key2 = "foo2"
	hash[key] = "bar" # create or update
	hash[key2] = "bar2"
	hash[key] # get
	hash.delete(key)
	
	hash.include?(key) # check for existence of a key (in simplevoc)
	
	hash.values_at([key, key2]) # get multiple values at once
	=> {"key" => "bar", "key2" => "bar2"}

The Simplevoc::Open::Hash class inherits from the Simplevoc::Open::Client, so you can use the regular client methods too. The Simplevoc::Open::Hash doesn't store any values locally, it always connects to Simplevoc.


Documentation & Tests
---------------------

Checkout the rdoc Documentation for more information. Generate the docs with "rake rdoc".

Use "rake test" to run the unit tests. The unit tests expect the SimpleVOC server to be started on port 12345 on your localhost:

  simplevoc --server.http-port=12345 --server.extended-key-values=name:string

To run the tests against an existing SimpleVOC installation on a different host or port, use the SIMPLEVOC_HOST / SIMPLEVOC_PORT environment variables. For example:

  SIMPLEVOC_HOST=localhost SIMPLEVOC_PORT=8080 rake test

Copyright
---------

Copyright (c) 2011 triAGENS GmbH. See LICENSE.txt for further details.

Author: Oliver Kiessler (kiessler@inceedo.com)
