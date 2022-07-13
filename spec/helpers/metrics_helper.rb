# frozen_string_literal: true

module Helpers
  module MetricsHelper
    CREATE_LIST = {
      day: 'create_list_day',
      hour: 'create_list_hour',
      minute: 'create_list_minute'
    }.freeze
    TIMESTAMP_FORMAT = {
      day: '%Y-%m-%dT00:00:00',
      hour: '%Y-%m-%dT%H:00:00',
      minute: '%Y-%m-%dT%H:%M:00'
    }.with_indifferent_access.freeze

    private_constant :CREATE_LIST
    private_constant :TIMESTAMP_FORMAT

    def create_list_metrics(timestamp:, per:)
      create_list_method = CREATE_LIST[per.to_sym]
      raise ArgumentError, "Period must be one of #{CREATE_LIST.keys.join(', ')}" if create_list_method.nil?

      method(create_list_method).call(timestamp)
    end

    def build_response(metrics_per_period, per)
      metrics_per_period.sort_by { |metric_period| metric_period[0][:timestamp] }
                        .map do |metric_period|
        {
          x: metric_period[0][:timestamp].strftime(TIMESTAMP_FORMAT[per]),
          y: (metric_period.sum(&:value) / metric_period.size).round(2)
        }.with_indifferent_access
      end
    end

    private

    def create_list_day(timestamp)
      count = Faker::Number.between(from: 1, to: 30)
      [create_list(:metric, count, timestamp:)]
    end

    def create_list_hour(timestamp)
      [['09:30', '09:59'], ['10:00', '10:01', '10:30', '10:59'], ['11:00', '11:01']].map do |times|
        times.map do |time|
          datetime = change_timestamp(timestamp, time:)
          create(:metric, timestamp: datetime)
        end
      end
    end

    def create_list_minute(timestamp)
      [['09:29:30', '09:29:59'], ['09:30:00', '09:30:01', '09:30:30', '09:30:59'], ['09:31:00', '09:31:01']].map do |times|
        times.map do |time|
          datetime = change_timestamp(timestamp, time:)
          create(:metric, timestamp: datetime)
        end
      end
    end

    def change_timestamp(timestamp, time:)
      hour, min, sec = time.split(':').map { |v| Integer(v || '0', 10) }
      timestamp.to_datetime.change(hour: hour || 0, min: min || 0, sec: sec || 0)
    end
  end
end
