# frozen_string_literal: true

class Metric < ApplicationRecord
  validates :name, presence: true
  validates :value, presence: true, numericality: true
  validates :timestamp, presence: true

  def self.average(per:)
    execute = <<-SQL.squish
      SELECT ROUND(AVG(value)::numeric, 2) as value,
             DATE_TRUNC('#{per}', timestamp) AS timestamp
      FROM metrics
      GROUP BY DATE_TRUNC('#{per}', timestamp)
      ORDER BY timestamp ASC
    SQL
    Metric.find_by_sql(execute)
  end
end
