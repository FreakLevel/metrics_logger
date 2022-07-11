# frozen_string_literal: true

module Helpers
  module MetricsHelper
    LEGEND = 'Average value of metrics per ? (UTC Time)'
    CREATE_LIST = {
      day: 'create_list_day',
      hour: 'create_list_hour',
      minute: 'create_list_minute'
    }.freeze
    private_constant :LEGEND
    private_constant :CREATE_LIST

    def create_list_metrics(timestamp:, per:)
      create_list_method = CREATE_LIST[per.to_sym]
      raise ArgumentError, "Period must be one of #{CREATE_LIST.keys.join(', ')}" if create_list_method.nil?

      method(create_list_method).call(timestamp)
    end

    def build_response(metrics_per_period, period)
      response = { labels: [], data: [], legend: LEGEND.gsub('?', period) }
      last_date = nil
      metrics_per_period.sort_by { |metric_period| metric_period[0][:timestamp] }
                        .each do |metric_period|
        if period.eql? 'day'
          response[:labels] << metric_period[0][:timestamp].strftime('%Y-%m-%d')
        else
          timestamp = metric_period[0][:timestamp]
          timestamp = timestamp.change(min: 0) if period.eql? 'hour'
          label = timestamp.strftime('%H:%M')
          if last_date.nil? || last_date.to_date != metric_period[0][:timestamp].to_date
            label = "#{metric_period[0][:timestamp].strftime('%Y-%m-%d')}  #{label}"
            last_date = metric_period[0][:timestamp]
          end
          response[:labels] << label
        end
        response[:data] << (metric_period.sum(&:value) / metric_period.size).round(2)
      end
      response
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
