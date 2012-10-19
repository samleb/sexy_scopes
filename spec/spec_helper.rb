$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'active_record'
require 'sexy_scopes'
require 'rspec'

class Arel::Nodes::Node
  # Arel no longer provides `Node#==`, implement it by considering two nodes equal
  # when they are instance of the same class and have the same instance variables.
  def ==(other)
    self.class == other.class && instance_variables == other.instance_variables && instance_variables.all? do |ivar|
      instance_variable_get(ivar) == other.instance_variable_get(ivar)
    end
  end
end

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  create_table :users do |t|
    t.string :username
  end
end

class User < ActiveRecord::Base
end
