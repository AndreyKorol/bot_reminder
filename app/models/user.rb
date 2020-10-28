class User < ApplicationRecord
  has_many :events
  validates :email, uniqueness: true, presence: true
  validates :chat_id, presence: true
end
