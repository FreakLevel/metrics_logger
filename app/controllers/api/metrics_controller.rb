# frozen_string_literal: true

module Api
  class MetricsController < Api::ApiController
    def index
      per = permitted_params[:per]
      metric_table = MetricTable.new(per)
      render json: metric_table.info
    rescue ArgumentError => e
      render json: { error: e.message }, status: :bad_request
    end

    def create
      name = permitted_params[:name]
      value = permitted_params[:value]
      timestamp = permitted_params[:timestamp] || Time.zone.now
      metric = Metric.create!(name:, value:, timestamp:)
      render json: metric, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: :bad_request
    end

    def list
      response = Metrics::List.perform(permitted_params)
      render json: response, status: :ok
    rescue ArgumentError => e
      render json: { error: e.message }, status: :bad_request
    end

    private

    def permitted_params
      params.permit(:per, :name, :value, :timestamp)
    end
  end
end
