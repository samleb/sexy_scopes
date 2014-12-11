class User < ActiveRecord::Base
  has_many :messages, foreign_key: 'author_id', inverse_of: :author
end

class Message < ActiveRecord::Base
  belongs_to :author, class_name: 'User', inverse_of: :messages
end
