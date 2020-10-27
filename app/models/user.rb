class User < ApplicationRecord
  has_many :events
  validates :email, uniqueness: true
end
