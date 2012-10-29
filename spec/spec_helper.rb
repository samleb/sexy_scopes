if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'rspec'
require 'active_record'
require 'sexy_scopes'

RSpec::Matchers.define :be_extended_by do |expected|
  match do |actual|
    extended_modules = actual.singleton_class.included_modules
    extended_modules.include?(expected)
  end
end

RSpec::Matchers.define :convert_to_sql do |expected|
  match do |actual|
    actual.to_sql == expected
  end
  
  description do
    "convert to the following SQL: #{expected}"
  end
  
  failure_message_for_should do |actual|
    "expected generated SQL to be \n  #{expected}\ngot\n  #{actual.to_sql}"
  end
end

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string  :username
    t.integer :score
  end
end

class User < ActiveRecord::Base
end
