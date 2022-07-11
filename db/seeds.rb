# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

## Create Metrics

count = 1
((Time.zone.today - 1.month)...Time.zone.today).each do |date|
  [
    '09:29:30', '09:29:59', '09:30:00', '09:30:01', '09:30:30', '09:30:59', '09:31:00', '09:31:01', '09:59', '10:00', '10:01', '10:30', '10:59',
    '11:00', '11:01'
  ].each do |time|
    hour, min, sec = time.split(':').map { |v| Integer(v || '0', 10) }
    timestamp = date.to_datetime.change(hour: hour || 0, min: min || 0, sec: sec || 0)
    Metric.create!(name: "Metrics ##{count}", value: rand(1..1000), timestamp:)
    count += 1
  end
end
