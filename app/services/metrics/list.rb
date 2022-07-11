# frozen_string_literal: true

module Metrics
  class List < BaseService
    attr_accessor :per, :timestamp

    PERIODS = {
      minute: -> (timestamp) { timestamp.change(sec: 0)..timestamp.change(sec: 59) },
      hour: -> (timestamp) { timestamp.change(min: 0)..timestamp.change(min: 59) },
      day: -> (timestamp) { timestamp.all_day }
    }.freeze

    private_constant :PERIODS

    def initialize(params)
      permitted_params(params)
      self.per = permitted_params['per']&.to_sym
      self.timestamp = permitted_params['timestamp']&.to_datetime
      validate!
    end

    def perform
      between_dates = PERIODS[per].call(timestamp)
      Metric.where(timestamp: between_dates).order(timestamp: :asc)
    end

    private

    def permitted_params(params = nil)
      @permitted_params ||= params.permit(:per, :timestamp)
    end

    def validate!
      raise ArgumentError, 'Period is required' if per.nil?
      raise ArgumentError, "Period must be one of #{PERIODS.keys.join(', ')}" unless PERIODS.keys.include?(per)
      raise ArgumentError, 'Timestamp is required' if timestamp.nil?
    end
  end
end
