# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sexy_scopes/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'sexy_scopes'
  gem.version       = SexyScopes::VERSION
  
  gem.summary = %{Write beautiful and expressive ActiveRecord scopes without SQL.}
  gem.description = %{Small DSL to create ActiveRecord (>= 3) attribute predicates without writing SQL.}
  
  gem.authors       = ['Samuel Lebeau']
  gem.email         = 'samuel.lebeau@gmail.com'
  gem.homepage      = 'https://github.com/samleb/sexy_scopes'

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  # gem.require_paths = ['lib']
  
  gem.licenses = ['MIT']
  
  gem.add_dependency 'activerecord', '~> 3.0'
  
  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'rspec', '~> 2.0'
  gem.add_development_dependency 'simplecov'
end
