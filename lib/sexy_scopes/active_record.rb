require 'sexy_scopes/active_record/class_methods'
require 'sexy_scopes/active_record/dynamic_methods'
require 'sexy_scopes/active_record/query_methods'

ActiveRecord::Base.extend SexyScopes::ActiveRecord::ClassMethods
ActiveRecord::Base.extend SexyScopes::ActiveRecord::DynamicMethods

ActiveRecord::Relation.send(:include, SexyScopes::ActiveRecord::QueryMethods)

ActiveRecord::QueryMethods::WhereChain.send(:prepend, SexyScopes::ActiveRecord::QueryMethods::WhereChainMethods)
