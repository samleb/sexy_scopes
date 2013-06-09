require 'active_record'
require 'sexy_scopes/active_record/class_methods'
require 'sexy_scopes/active_record/dynamic_methods'

ActiveRecord::Base.extend SexyScopes::ActiveRecord::ClassMethods
ActiveRecord::Base.extend SexyScopes::ActiveRecord::DynamicMethods
