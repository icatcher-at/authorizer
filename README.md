# Authorizer

## Description
Object oriented authorization for Rails applications in the YFU ecosystem.

## Installation

    gem 'authorizer', github: 'icatcher-at/authorizer'

## Authorizer Classes

Authorization is implemented with the help of [policy objects][1]. To make an authorizer, a class should inherit from `Authorizer::Base` and implement predicate instance methods.

    class ImageAuthorizer < Authorizer::Base
      # public instance available
      #   user          -> amounts to current_user by default
      #   organization  -> amounts to current_organization by default
      #   affiliation   -> amountes to current_affiliation by default
      #   record        -> the record that is being tested, also aliased as object
    
      def download?
        record.user == user
      end
  
      def zip?
        record.organization == organization
      end
    end

    @image = Image.find(1)
    authorizer = ImageAuthorizer.new(current_user, current_affiliation, current_organization, @image)

    authorizer.download?  #=> true
    authorizer.zip?       #=> false

## Action Controller Helpers

To make life easier the Authorizer module offers `ActionControllerExtensions` to easily integrate authorization in your views and controllers:

    class SomeController < ApplicationController
      def new
        @post = Post.new
        authorized?(@post, :new)  #=> true or false
        authorize!(@post, :new)   #=> raises Authorizer::NotAuthorizedError if false
      end
    end
    
To further the magic both methods invoke the `action_name` method if the second parameter is omitted:

    class SomeController < ApplicationController
      def new
        @post = Post.new
        authorized?(@post)  #=> same as: authorized?(@post, :new)
        authorize!(@post,)  #=> same as: authorize!(@post, :new)
      end
    end



[1]: http://eng.joingrouper.com/blog/2014/03/20/rails-the-missing-parts-policies/