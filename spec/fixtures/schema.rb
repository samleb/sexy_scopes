SexyScopesSpec.connect

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string  :username
    t.integer :score
  end
end
