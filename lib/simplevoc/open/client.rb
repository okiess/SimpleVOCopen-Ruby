# Copyright:: 2011 triAGENS GmbH
# Author:: Oliver Kiessler (mailto:kiessler@inceedo.com)
module Simplevoc
  module Open
    # You can setup the client by passing options into the constructor or by using a configuration file in YAML.
    # client = Simplevoc::Open::Client.new('host' => 'localhost', 'port' => 12345)
    #
    # To avoid exceptions, create a client in non-strict mode
    #
    # client = Simplevoc::Open::Client.new('host' => 'localhost', 'port' => 12345, 'log_level' => LOGGER::DEBUG, 'strict_mode' => false)
    class Client < Base
      # The insert method creates a new key-value pair in SimpleVOC.
      # === Parameters
      # * key = Key string
      # * value = Value string
      # * options = Optional header options hash with meta values for the values (x-voc-expires, x-voc-flags, x-voc-delete-time, x-voc-flush-delay, x-voc-extended)
      def insert(key, value, options = {})
        if key and value
          response = get_response(:post, "/value/#{key}", options.merge(:body => value.to_s))
          if response and response.parsed_response
            return true if response.response.is_a?(Net::HTTPOK) and not response.parsed_response["error"] and response.parsed_response["message"] == MESSAGES[:stored]
            if response.parsed_response["message"] == MESSAGES[:insert_failed]
              raise Simplevoc::Open::ValueExistsException, MESSAGES[:insert_failed] if use_strict_mode?
            else
              raise Simplevoc::Open::OperationFailedException, response.parsed_response["message"] if use_strict_mode?
            end
          end
        else
          raise Simplevoc::Open::EmptyKeyException if use_strict_mode? and not key
          raise Simplevoc::Open::EmptyValueException if use_strict_mode? and not value
        end
        false
      end

      # Convenience method to insert a key-value pair with extended values. The extended value is expected to be a JSON formatted string with
      # key-values know to the SimpleVOC server. The server needs to be started with the "--server.extended-key-values=your_key:your_type" argument.
      # === Parameters
      # * key = Key string
      # * value = Value string
      # * extended_values_json = JSON string
      # * options = Options headers hash
      def insert_with_extended_values(key, value, extended_values_json, options = {})
        json = extended_values_json.is_a?(String) ? extended_values_json : extended_values_json.to_json
        insert(key, value, options.merge(:headers => {'x-voc-extended' => json}))
      end

      # Updates an existing key-value. The key must exist in SimpleVOC, otherwise an exception is raised.
      # === Parameters
      # * key = Key string
      # * value = Value string
      # * options = Options headers hash
      def update(key, value, options = {})
        if key and value
          response = get_response(:put, "/value/#{key}", options.merge(:body => value.to_s))
          if response and response.parsed_response
            return true if response.response.is_a?(Net::HTTPOK) and not response.parsed_response["error"] and response.parsed_response["message"] == MESSAGES[:stored]
            if response.parsed_response["message"] == MESSAGES[:update_failed]
              raise Simplevoc::Open::KeyNotFoundException, MESSAGES[:update_failed] if use_strict_mode?
            else
              raise Simplevoc::Open::OperationFailedException, response.parsed_response["message"] if use_strict_mode?
            end
          end
        else
          raise Simplevoc::Open::EmptyKeyException if use_strict_mode? and not key
          raise Simplevoc::Open::EmptyValueException if use_strict_mode? and not value
        end
        false
      end

      # Convenience method to insert or update a key-value pair in one go. Raises an exception if the key doesn't exist in SimpleVOC.
      # === Parameters
      # * key = Key string
      # * value = Value string
      # * options = Options headers hash
      def insert_or_update(key, value, options = {})
        if key and value
          response = get_response(:put, "/value/#{key}?create=1", options.merge(:body => value.to_s))
          if response and response.parsed_response
            return true if response.response.is_a?(Net::HTTPOK) and not response.parsed_response["error"] and response.parsed_response["message"] == MESSAGES[:stored]
            raise Simplevoc::Open::OperationFailedException, response.parsed_response["message"] if use_strict_mode?
          end
        else
          raise Simplevoc::Open::EmptyKeyException if use_strict_mode? and not key
          raise Simplevoc::Open::EmptyValueException if use_strict_mode? and not value
        end
        false
      end

      # Deletes a key-value pair in SimpleVOC identified by its key. Raises an exception if the key doesn't exist in SimpleVOC.
      # === Parameters
      # * key = Key string
      def delete(key)
        if key
          response = get_response(:delete, "/value/#{key}")
          if response and response.parsed_response
            return true if response.response.is_a?(Net::HTTPOK) and not response.parsed_response["error"] and response.parsed_response["message"] == MESSAGES[:deleted]
            if response.parsed_response["message"] == MESSAGES[:delete_failed]
              raise Simplevoc::Open::KeyNotFoundException, MESSAGES[:delete_failed] if use_strict_mode?
            else
              raise Simplevoc::Open::OperationFailedException, response.parsed_response["message"] if use_strict_mode?
            end
          end
        else
          raise Simplevoc::Open::EmptyKeyException if use_strict_mode?
        end
        false
      end

      # Returns a hash with the value and known meta information about a given key. Raises an exception if the key doesn't exist in SimpleVOC.
      # === Parameters
      # * key = Key string
      # * with_response_headers = true/false, set to true if you only want the value
      def get(key, with_response_headers = true)
        if key
          response = get_response(:get, "/value/#{key}")
          if response and response.parsed_response
            if response.response.is_a?(Net::HTTPOK)
              if with_response_headers
                sv_response = {'value' => response.parsed_response}
                sv_response['created'] = DateTime.parse(response.headers['x-voc-created']) if response.headers['x-voc-created']
                sv_response['expires'] = DateTime.parse(response.headers['x-voc-expires']) if response.headers['x-voc-expires']
                sv_response['flags'] = response.headers['x-voc-flags'].to_i if response.headers['x-voc-flags']
                sv_response['extended-values'] = JSON response.headers['x-voc-extended'] if response.headers['x-voc-extended']
                return sv_response
              else
                return response.parsed_response
              end
            elsif response.parsed_response.is_a?(::Hash) and response.parsed_response["error"] and response.parsed_response["message"] == MESSAGES[:get_failed]
              raise Simplevoc::Open::KeyNotFoundException, MESSAGES[:get_failed] if use_strict_mode?
            end
          end
        else
          raise Simplevoc::Open::EmptyKeyException if use_strict_mode?
        end
        nil
      end

      # Returns an array of known keys. Use a prefix to query for keys and you can also use a filter expression. Raises an exception if the prefix is
      # unknown or doesn't match.
      # === Parameters
      # * prefix = Prefix string
      # * filter = Optional filter expression
      def keys(prefix, filter = nil)
        if prefix
          response = get_response(:get, filter ? "/keys/#{prefix}?filter=#{filter}" : "/keys/#{prefix}")
          if response.response.is_a?(Net::HTTPOK)
            return response.parsed_response
          elsif response.response.is_a?(Net::HTTPNoContent)
            raise Simplevoc::Open::NoContentAtURLPathException if use_strict_mode?
          else
            raise Simplevoc::Open::PrefixNotFoundException if use_strict_mode?
          end
        else
          raise Simplevoc::Open::EmptyPrefixException if use_strict_mode?
        end
        nil
      end

      # Deletes all key-value pairs in SimpleVOC.
      def flush
        response = get_response(:put, "/flush")
        if response and response.parsed_response
          return true if response.response.is_a?(Net::HTTPOK) and response.parsed_response["message"] == MESSAGES[:flush]
          raise Simplevoc::Open::OperationFailedException, response.parsed_response["message"] if use_strict_mode?
        end
        false
      end

      # Returns information about the SimpleVOC server.
      def server_info
        info = {}
        response = get_response(:get, '/version')
        if response and response.parsed_response
          info['version'] = response.parsed_response['version']
          info['server'] = response.header['server']
        end
        info
      end

      # Returns the server version of the SimpleVOC server.
      def server_version
        server_info['version']
      end

      # Convenience method to create a option headers hash with common attributes.
      # === Parameters
      # * expires
      # * flags
      # * delete_time
      # * flush_delay
      # === Examples
      # expires = your_time_object.utc.iso8601
      # flags = 1
      def extra_options(expires = nil, flags = nil, delete_time = nil, flush_delay = nil)
        options = {:headers => {}}
        options[:headers]['x-voc-expires'] = expires.to_s if expires
        options[:headers]['x-voc-flags'] = flags.to_s if flags
        options[:headers]['x-voc-delete-time'] = delete_time.to_s if delete_time
        options[:headers]['x-voc-flush-delay'] = flush_delay.to_s if flush_delay
        logger.debug "Using header options: #{options[:headers].inspect}"
        options
      end

      private
      # Internal method to create the httparty request and return the http response that is already parsed by httparty.
      # === Parameters
      # * http_verb = HTTP verb symbol (:get, :post, :put, :delete)
      # * endpoint = HTTP URL endpoint
      # * options = Optional options with body and headers 
      def get_response(http_verb, endpoint, options = {})
        begin
          endpoint_value = "#{base_url}#{URI.escape(endpoint)}"
          logger.debug "Using endpoint: #{endpoint_value}"
          body = {}; body.merge!(options) if options and options.any?
          response = (http_verb == :post or http_verb == :put) ? HTTParty.send(http_verb, endpoint_value, body) : HTTParty.send(http_verb, endpoint_value)
          logger.debug "Response: #{response.inspect}" if response
          response
        rescue => e
          logger.error("Could not connect to SimpleVOC: #{e.message}")
          raise Simplevoc::Open::ConnectionRefusedException
        end
      end
    end
  end
end
