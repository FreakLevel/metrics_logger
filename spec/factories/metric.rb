# frozen_string_literal: true

FactoryBot.define do
  factory :metric do
    name { Faker::Lorem.word }
    value { Faker::Number.within(range: 1..99_999) }
    timestamp { Faker::Time.between_dates(from: Time.zone.today - 5.years, to: Time.zone.today, period: :all) }
  end
end
