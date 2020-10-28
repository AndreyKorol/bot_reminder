class Event < ApplicationRecord
  belongs_to :user
  validate :name, presence: true
  validate :date, presence: true
end
