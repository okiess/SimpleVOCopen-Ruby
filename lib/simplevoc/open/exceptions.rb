# Copyright:: 2011 triAGENS GmbH
# Author:: Oliver Kiessler (mailto:kiessler@inceedo.com)
module Simplevoc
  module Open
    # The ConfigurationMissingException is raised when no configuration options are provided
    # to the client constructor, a config.yml is missing in the current directory or a global
    # configuration can't be found in the home directory.
    class ConfigurationMissingException < Exception; end
  
    # The EmptyKeyException is raised when an empty key was passed to the Client#insert, Client#insert_or_update,
    # Client#update or Client#delete methods.
    class EmptyKeyException < Exception; end
  
    # The EmptyValueException is raised when nil is passed into a Client#insert, Client#insert_or_update or 
    # Client#update method.
    class EmptyValueException < Exception; end
  
    # The ValueExistsException is raised when a value for an existing key is passed to the Client#insert method.
    class ValueExistsException < Exception; end

    # The ConnectionRefusedException is raised when the HTTP connection to the SimpleVOC server fails.
    class ConnectionRefusedException < Exception; end
  
    # The KeyNotFoundException is raised when a key doesn't exist during a Client#get method call.
    class KeyNotFoundException < Exception; end
  
    # The OperationFailedException is a general exception that is raised during a REST method call. Returns the error
    # message from the SimpleVOC server.
    class OperationFailedException < Exception; end
  
    # The EmptyPrefixException is raised when no prefix is passed to the Client#keys method.
    class EmptyPrefixException < Exception; end
  
    # The PrefixNotFoundException is raised when the Client#keys method doesn't return a result for a given prefix.
    class PrefixNotFoundException < Exception; end
  
    # The NoContentAtURLPathException can be raised by the Client#keys method when the given prefix can't be interpreted.
    class NoContentAtURLPathException < Exception; end
  end
end
