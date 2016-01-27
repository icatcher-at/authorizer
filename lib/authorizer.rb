require 'authorizer/active_record_ext'
require 'authorizer/action_controller_ext'
require 'authorizer/base'

module Authorizer

  ##
  # Gets raised when authorization goes wrong.
  #
  class NotAuthorizedError < StandardError
    
  end

  ##
  # Gets raised when no respective authorizer class
  # can be inferred.
  #
  class UninferrableAuthorizerError < NameError
    def initialize(klass)
      super("Could not infer an authorizer for #{klass}.")
    end
  end

end
