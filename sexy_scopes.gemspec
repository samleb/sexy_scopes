# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sexy_scopes/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'sexy_scopes'
  gem.version       = SexyScopes::VERSION

  gem.summary = %{Write beautiful and expressive ActiveRecord scopes without SQL.}
  gem.description = %{Small DSL to create ActiveRecord (>= 3.1) attribute predicates without writing SQL.}

  gem.authors       = ['Samuel Lebeau']
  gem.email         = 'samuel.lebeau@gmail.com'
  gem.homepage      = 'https://github.com/samleb/sexy_scopes'

  gem.files         = Dir['*.md', 'LICENSE', 'lib/**/*.rb']

  gem.licenses = ['MIT']

  gem.required_ruby_version = '>= 2.0.0'

  gem.add_dependency 'activerecord', '>= 4.0'

  gem.add_development_dependency 'appraisal', '~> 2.1'
  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '>= 0.9'
  gem.add_development_dependency 'rspec', '~> 3.0'
  if RUBY_ENGINE == 'jruby'
    gem.add_development_dependency 'jdbc-sqlite3', '~> 3.0'
    gem.add_development_dependency 'activerecord-jdbcsqlite3-adapter'
    gem.add_development_dependency 'activerecord-jdbcmysql-adapter', '~> 1.0'
    gem.add_development_dependency 'activerecord-jdbcpostgresql-adapter', '~> 1.0'
    gem.add_development_dependency 'kramdown', '~> 1.2'
  else
    gem.add_development_dependency 'mysql2', '~> 0.4.9'
    gem.add_development_dependency 'pg', '~> 0.8'
    gem.add_development_dependency 'sqlite3', '~> 1.3.6'
    gem.add_development_dependency 'redcarpet', '~> 3.0'
  end
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'simplecov'
end
