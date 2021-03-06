# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

## Create Metrics
count = 0
((Time.zone.today - 2.days)...Time.zone.today).each do |date|
  4_000.times.each do
    timestamp = (date + rand(0..23).hours + rand(0..59).minutes + rand(0..59).seconds).to_datetime
    Metric.create!(name: "Metrics ##{count}", value: rand(1..100), timestamp:)
    count += 1
  end
end
