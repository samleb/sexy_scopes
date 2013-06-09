module SexyScopes
  class Railtie < Rails::Railtie
    initializer 'sexy_scopes' do |app|
      ActiveSupport.on_load :active_record do
        require 'sexy_scopes/active_record'
      end
    end
  end
end
