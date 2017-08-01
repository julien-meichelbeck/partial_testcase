# frozen_string_literal: true
$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'partial_testcase/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'partial_testcase'
  s.version     = PartialTestcase::VERSION
  s.authors     = ['Julien Meichelbeck']
  s.email       = ['julien.meichelbeck@gmail.com']
  s.homepage    = 'https://github.com/julien-meichelbeck/partial_testcase'
  s.summary     = 'Unit test your view layer'
  s.description = 'PartialTestcase is a gem providing unit tests for your partials.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1.1'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rubocop'
end
