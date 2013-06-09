require 'sexy_scopes/version'
require 'active_support/dependencies/autoload'

module SexyScopes
  extend ActiveSupport::Autoload
  
  autoload :Wrappers
end

if defined? Rails::Railtie
  require 'sexy_scopes/railtie'
else
  require 'sexy_scopes/active_record'
end
