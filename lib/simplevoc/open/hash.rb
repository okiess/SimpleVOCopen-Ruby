# Copyright:: 2011 triAGENS GmbH
# Author:: Oliver Kiessler (mailto:kiessler@inceedo.com)
module Simplevoc
  module Open
    # The Simplevoc Hash serves as a simple non-strict mode alternative to the regular client class.
    #
    # hash = Simplevoc::Open::Hash.new('host' => 'localhost', 'port' => 12345)
    #
    # === Examples:
  	# hash["key"] = "value" (create or update)
  	#
  	# hash["key"] (get)
  	#
  	# hash.delete("key")
  	#
  	# hash.include?("key") (check for existence of a key in simplevoc)
  	#
  	# hash.values_at(["key", "key2"]) (get multiple values at once)
  	#
  	# returns: {"key" => "value", "key2" => "value2"}
    class Hash < Client
      # === Parameters
      # * host = Hostname (required)
      # * port = Port (required)
      # * protocol = "http"/"https", defaults to "http"
      # * strict_mode = true/false, defaults to false
      # * log_level = defaults to LOGGER::INFO
      def initialize(options = {})
        super(options.merge('strict_mode' => false))
      end

      # Insert key-value pair.
      def []=(key, value)
        insert_or_update(key, value)
      end
      # Alias for Hash#[]=.
      def store(key, value); self[key] = value; end

      # Getter for key-value pair.
      def [](key)
        get(key, false)
      end
      # Alias for Hash#[].
      def fetch(key); self[key]; end

      # Checks for the existance of a key-value pair in SimpleVOC.
      def has_key?(key)
        not get(key, false).nil?
      end
      # Alias for Hash#has_key?.
      def include?(key); self.has_key?(key); end
      # Alias for Hash#has_key?.
      def key?(key); self.has_key?(key); end
      # Alias for Hash#has_key?.
      def member?(key); self.has_key?(key); end

      # Convenience method to fetch values for a given list of keys.
      def values_at(keys = [])
        return_values = {}
        keys.each {|key| return_values[key] = get(key, false)}
        return_values
      end

      # Alias for Client#flush.
      def clear; flush; end
    end
  end
end
