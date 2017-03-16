##
# Defines a set of classes and methods to help with authorization.
#
# Authorization is implemented with the help of policy objects. To make an authorizer a class should inherit from Authorizer::Base and implement
# predicate instance methods.
#
#     class ImageAuthorizer < Authorizer::Base
#       def download?
#         user.images.include?(record)
#       end
#     end
#
#     @image = Image.find(1)
#     authorizer = ImageAuthorizer.new(current_user, current_user_affiliation, current_organization, @image)
#     authorizer.download?
#
# To make life easier the Authorizer module offers ActionControllerExtensions to easily integrate authorization in your views and controllers.
#
module Authorizer

  ##
  # Represents the base class of any authorizer object.
  #
  class Base
    # returns the User object.
    attr_reader :user

    # returns the record object.
    attr_reader :record
    alias_method :object, :record

    # returns the Affiliation object
    attr_reader :affiliation

    # returns the Organization object
    attr_reader :organization

    ##
    # Create a new Authorizer for the given +user+, +affiliation+, +organization+ and +record+.
    #
    def initialize(u, a, o, r)
      @user         = u
      @affiliation  = a
      @organization = o
      @record       = r
    end

    ##
    # Raises a RuntimeError in +development+ and +test+ environment if a method is called that
    # isn't defined on the parent class. In other environments it returns +false+,
    # assuming the action is unauthorized.
    #
    def method_missing(m, *args, &block)
      if Rails.env.development? || Rails.env.test?
        raise RuntimeError, "#{self.class.name} does not define #{m}!"
      else
        false
      end
    end


    private

    ##
    # Delegates a +permissions+ call to the +affiliations+ object.
    #
    def permissions
      @permissions ||= affiliation.permissions
    end
  end

end
