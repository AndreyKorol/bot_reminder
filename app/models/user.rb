class User < ApplicationRecord
  has_many :events
  validates :email, uniqueness: true, presence: true
  validates :chat_id, presence: true
  scope :with_active_events, -> { where(events: { date: DateTime.now.. }) }
end
