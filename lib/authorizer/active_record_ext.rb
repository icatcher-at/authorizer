module Authorizer

  ##
  # Adds helper methods of the Authorizer module to ActiveRecord::Base
  #
  module ActiveRecordExtensions

    module InstanceMethods
      delegate :authorizer_class, to: :class
    end

    module ClassMethods
      def authorizer_class
        prefix = (respond_to?(:model_name) ? model_name : name).to_s
        prefix << 'Module' if is_a?(Module)

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
    end

  end
end

ActiveRecord::Base.send(:include, Authorizer::ActiveRecordExtensions::InstanceMethods)
ActiveRecord::Base.send(:extend, Authorizer::ActiveRecordExtensions::ClassMethods)
