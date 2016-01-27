module Authorizer
  ##
  # Adds helper methods of the Authorizer module to ActionController::Base
  #
  module ActionControllerExtensions

    ##
    # Returns a child object of Authorizer::Base for the given +record+ object injecting a +user+ object.
    # Invokes the +current_user+ method by default if +user+ is ommited. +record+ can be of any type (object instance, class or module).
    # If the given +record+ is a Module it tries to instantiate a module authorizer.
    #
    # The method is also available as a helper method in your views.
    #
    # ==== Example:
    #    authorizer_object(Post.new).class
    #    # => PostAuthorizer
    #
    #    authorizer_object(Post.new, present_user).class
    #    # => PostAuthorizer
    #
    #    authorizer_object(Post, present_user).class
    #    # => PostAuthorizer
    #
    #    authorizer_object(Executables, present_user).class
    #    # => ExecutablesModuleAuthorizer
    #
    def authorizer_object(record, user = current_user, affiliation = current_affiliation, organization = current_organization)
      record.authorizer_object.new(user, affiliation, organization, record)
    end


    ##
    # Creates an authorized object of the given +record+ object and invokes +action_name_to_authorize+
    # as a predicate method.
    #
    # The method is also available as a helper method in your views.
    #
    # ==== Example:
    #    authorized?(@post, :new)
    #    # same as
    #    #   authorizer_object(@post).new?
    #
    def authorized?(record, action_name_to_authorize)
      authorizer_object(record).public_send("#{action_name_to_authorize}?")
    end


    ##
    # Creates an Authorizer object of the given +record+ and invokes the +action_name_to_authorize+
    # as a predicate method on it. If +action_name_to_authorize+ is ommited it defaults to +action_name+
    # from ActionController::Base.
    #
    # The method is also available as a helper method in your views.
    #
    # ==== Example:
    #    class PostsController < ActionController::Base
    #      def edit
    #        @post = Post.first
    #        authorize!(@post)
    #        # same as
    #        #   authorizer_object(@post).edit?
    #      end
    #    end
    #
    def authorize!(record, action_name_to_authorize = action_name)
      raise Authorizer::NotAuthorizedError unless authorized?(record, action_name_to_authorize)
    end


    def self.included(c) #:nodoc:
      c.helper_method :authorizer_object
      c.helper_method :authorized?
      c.helper_method :authorize!
    end

  end
end

ActionController::Base.send(:include, Authorizer::ActionControllerExtensions)
