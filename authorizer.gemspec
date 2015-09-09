$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'authorizer/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'authorizer'
  s.version     = Authorizer::VERSION
  s.authors     = ['Robert Neumayr']
  s.email       = ['kontakt@icatcher.at']
  s.summary     = 'Provides authorization objects for Ruby On Rails models in the YFU ecosystem with the use of policy classes.'
  s.description = 'Object oriented authorization for Rails applications in the YFU ecosystem.'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '>= 4.0'

  s.add_development_dependency 'rspec', '~> 3.0'
end
