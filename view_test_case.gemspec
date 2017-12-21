# frozen_string_literal: true
$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'view_test_case/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'view_test_case'
  s.version     = ViewTestCase::VERSION
  s.authors     = ['Julien Meichelbeck']
  s.email       = ['julien.meichelbeck@gmail.com']
  s.homepage    = 'https://github.com/julien-meichelbeck/view_test_case'
  s.summary     = 'Unit test your view layer'
  s.description = 'ViewTestCase is a gem providing unit tests for your Rails views.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1.1'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rubocop'
end
