class AuthorizerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  
  def generate_authorizer
    template 'authorizer.rb', File.join('app', 'authorizers', class_path, "#{file_name}_authorizer.rb")
  end
  
end
