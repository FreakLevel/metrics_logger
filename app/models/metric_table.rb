# frozen_string_literal: true

class MetricTable
  attr_accessor :period

  PERIODS = %w[minute hour day].freeze

  private_constant :PERIODS

  def initialize(period)
    @period = period
    validate!
  end

  def info
    metric_table = Metric.average(per: period)
    metric_table.map do |metric_data|
      { x: metric_data.timestamp.strftime('%Y-%m-%dT%H:%M:%S'), y: metric_data.value }
    end
  end

  private

  def validate!
    raise ArgumentError, 'Period is required' if period.nil?
    raise ArgumentError, "Period must be one of #{PERIODS.join(', ')}" unless PERIODS.include?(period)
  end

  def set_values
    metric_table = Metric.average(per: period)
    metric_table.each do |metric_data|
      @data << { x: metric_data.timestamp.strftime('%Y-%m-%dT%H:%M:%S'), y: metric_data.value }
    end
  end
end
