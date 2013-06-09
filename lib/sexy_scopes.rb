require 'sexy_scopes/version'
require 'active_support/dependencies/autoload'
require 'active_support/lazy_load_hooks'

module SexyScopes
  extend ActiveSupport::Autoload
  
  autoload :Wrappers
end

if defined? Rails::Railtie
  require 'sexy_scopes/railtie'
else
  ActiveSupport.on_load :active_record do
    require 'sexy_scopes/active_record'
  end
end
