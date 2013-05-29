ActiveRecord::Base.establish_connection(
  :adapter => RUBY_ENGINE == "jruby" ? "jdbcsqlite3" : "sqlite3",
  :database => ":memory:"
)

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string  :username
    t.integer :score
  end
end
