require 'authorizer/base'

class Affiliation < Struct.new(:organization, :user)
  
  def permissions
    'anything'
  end
end

class Post
  def to_s; 'Post'; end
  def inspect; '<Post>'; end
end

class PostAuthorizer < Authorizer::Base
  
  def read?
    true
  end
  
  def edit?
    false
  end
  
end