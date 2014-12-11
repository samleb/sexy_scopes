SexyScopesSpec.connect

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string  :username
    t.integer :score
  end

  create_table :messages, force: true do |t|
    t.references :author
    t.string :body
  end
end
