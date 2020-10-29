class Event < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :date, presence: true

  def to_s
    "#{name} - #{date.in_time_zone('Minsk').strftime('%a, %d %b %Y %R')} - #{description}"
  end
end
