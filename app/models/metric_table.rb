# frozen_string_literal: true

class MetricTable
  attr_reader :legend, :labels, :data
  attr_accessor :period

  PERIODS = %w[minute hour day].freeze
  private_constant :PERIODS

  def initialize(period)
    @period = period
    validate!
  end

  def info
    set_values
    {
      legend:,
      labels:,
      data:
    }
  end

  private

  def validate!
    raise ArgumentError, 'Period is required' if period.nil?
    raise ArgumentError, "Period must be one of #{PERIODS.join(', ')}" unless PERIODS.include?(period)
  end

  def set_values
    info = Metric.average(per: period)
    @legend = "Average value of metrics per #{period} (UTC Time)"
    get_labels(info)
    @data = info.pluck(:value)
  end

  def get_labels(info)
    last_date = nil
    @labels = info.pluck(:timestamp).map do |timestamp|
      next timestamp.strftime('%Y-%m-%d') if period.eql? 'day'

      label = timestamp.strftime('%H:%M')
      if last_date.nil? || last_date.to_date != timestamp.to_date
        label = "#{timestamp.strftime('%Y-%m-%d')}  #{label}"
        last_date = timestamp
      end
      label
    end
  end
end
