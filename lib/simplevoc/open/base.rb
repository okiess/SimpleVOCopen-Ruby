# Copyright:: 2011 triAGENS GmbH
# Author:: Oliver Kiessler (mailto:kiessler@inceedo.com)
module Simplevoc
  module Open
    # This ruby library is a REST client for the SimpleVOC key/value store.
    #
    # SimpleVOC is a pure in-memory key/value store with a REST Interface. It was developed with easy installation, administration 
    # and operation in mind. Checkout [World of Voc](http://www.worldofvoc.com) for more information.
    class Base
      VERSION = '1.0.0'
      attr_accessor :configuration, :logger

      # SimpleVOC messages used in the response JSON.
      MESSAGES = {
        :stored => "stored",
        :insert_failed => "use 'PUT /value/<key>' to overwrite value",
        :deleted => "deleted",
        :delete_failed => 'key not found',
        :get_failed => 'key not found',
        :update_failed => 'not stored',
        :flush => 'flush started'
      }

      # === Parameters
      # * host = Hostname (required)
      # * port = Port (required)
      # * protocol = "http"/"https", defaults to "http"
      # * strict_mode = true/false, defaults to true
      # * log_level = defaults to LOGGER::INFO
      def initialize(options = {})
        default_options = {'host' => 'localhost', 'port' => '12345', 'protocol' => 'http', 'log_level' => Logger::INFO, 'strict_mode' => true}
        options = default_options.merge(options)
        options.empty? ? read_configuration : self.configuration = Simplevoc::Open::Configuration.new(options)
        self.logger = Logger.new(STDOUT)
        self.logger.level = options['log_level']
        self.logger.info("SimpleVOC Ruby Client Version: #{VERSION}")
      end

      protected
      # Reads the configuration from the current directory and when it doesn't find it falls back to the
      # global configuration in the home directory (~/.simplevoc.yml) under which this ruby interpreter is run.
      def read_configuration
        if File.exists?("config.yml")
          puts "Using config in this directory"
          self.configuration = Simplevoc::Open::Configuration.new(YAML.load(File.read("config.yml")))
        else
          begin
            puts "Using config in your home directory"
            self.configuration = Simplevoc::Open::Configuration.new(YAML.load(File.read("#{ENV['HOME']}/.simplevoc.yml")))
          rescue Errno::ENOENT
            raise Simplevoc::Open::ConfigurationMissingException, "config.yml expected in current directory or ~/.simplevoc.yml"
          end
        end
      end

      # Returns the HTTP base URL for the SimpleVOC Rest Service.
      def base_url
        "#{self.configuration.options['protocol']}://#{self.configuration.options['host']}:#{self.configuration.options['port']}"
      end

      # Returns true/false whether to use the client in strict-mode or not.
      # In strict-mode exceptions are raised for the most common client operations.
      def use_strict_mode?
        self.configuration.options['strict_mode']
      end
    end
  end
end
