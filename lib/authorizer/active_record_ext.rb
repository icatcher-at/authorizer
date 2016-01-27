module Authorizer

  ##
  # Adds helper methods of the Authorizer module to ActiveRecord::Base
  #
  module ActiveRecordExtensions

    def self.authorizer_class
      prefix = respond_to?(:model_name) ? model_name : name
      prefix << 'Module' if self.is_a?(Module)

      authorizer_name = "#{prefix}Authorizer"
      authorizer_name.constantize
    rescue NameError => error
      if respond_to?(:superclass) && superclass.respond_to?(:authorizer_class)
        superclass.authorizer_class
      else
        raise unless error.missing_name?(authorizer_name)
        raise Authorizer::UninferrableAuthorizerError(self)
      end
    end

    delegate :authorizer_class, to: :class

  end
end

ActiveRecord::Base.send(:include, Authorizer::ActiveRecordExtensions)
