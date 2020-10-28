FactoryBot.define do
  factory :event do
    name { 'Event' }
    date { DateTime.now + 1.hour }
    description { 'default description' }
  end
end
