require 'sexy_scopes/version'
require 'active_support/lazy_load_hooks'
require 'active_support/dependencies/autoload'

module SexyScopes
  extend ActiveSupport::Autoload
  
  autoload :Wrappers
end

ActiveSupport.on_load(:active_record) do
  require 'sexy_scopes/active_record'
end
