if defined? Rails::Railtie
  require 'sexy_scopes/railtie'
else
  require 'sexy_scopes/active_record'
end
