# frozen_string_literal: true

require 'rails_helper'

DAYS = ((Time.zone.today - 2.days)..Time.zone.today).to_a

RSpec.describe Api::MetricsController, type: :request do
  describe 'GET #index' do
    %w[day hour minute].each do |per|
      context "per #{per}" do
        before do
          metrics = []
          DAYS.each do |day|
            create_list_metrics(timestamp: day, per:).each { |metric| metrics << metric }
          end
          @expected_response = build_response(metrics, per)
          get '/api/metrics', params: { per: }
        end

        include_examples 'metrics_controller_index' do
          let(:expected_response) { @expected_response }
        end
      end
    end

    context 'request failure' do
      context 'invalid period' do
        before { get '/api/metrics', params: { per: 'second' } }

        it 'returns a failure response' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error message' do
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to start_with 'Period must be one of'
        end
      end

      context 'invalid params' do
        before { get '/api/metrics', params: { invalid: 'param' } }

        it 'returns a failure response' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error message' do
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq('Period is required')
        end
      end
    end
  end

  describe 'POST #create' do
    context 'success' do
      context 'all params' do
        let(:metric) { build(:metric) }

        before { post '/api/metrics', params: { name: metric.name, value: metric.value, timestamp: metric.timestamp } }

        it 'returns a success response' do
          expect(response).to have_http_status(:created)
        end

        it 'returns a metric' do
          json_response = JSON.parse(response.body)
          expect(json_response['name']).to eq(metric.name)
          expect(json_response['value']).to eq(metric.value)
          expect(DateTime.parse(json_response['timestamp'])).to eq(metric.timestamp.to_datetime)
        end
      end

      context 'missing timestamp' do
        let(:metric) { build(:metric, timestamp: nil) }

        before { post '/api/metrics', params: { name: metric.name, value: metric.value } }

        it 'returns a success response' do
          expect(response).to have_http_status(:created)
        end

        it 'returns a metric' do
          json_response = JSON.parse(response.body)
          expect(json_response['name']).to eq(metric.name)
          expect(json_response['value']).to eq(metric.value)
          expect(DateTime.parse(json_response['timestamp'])).to be_within(1.second).of(Time.zone.now.to_datetime)
        end
      end
    end

    context 'failure' do
      context 'invalid params' do
        context 'all invalid' do
          before { post '/api/metrics', params: { invalid: 'param' } }

          it 'returns a failure response' do
            expect(response).to have_http_status(:bad_request)
          end

          it 'returns an error message' do
            json_response = JSON.parse(response.body)
            expect(json_response['error']).to eq("Validation failed: Name can't be blank, Value can't be blank, Value is not a number")
          end
        end

        context 'value is not a number' do
          before { post '/api/metrics', params: { value: 'text', name: 'name' } }

          it 'returns a failure response' do
            expect(response).to have_http_status(:bad_request)
          end

          it 'returns an error message' do
            json_response = JSON.parse(response.body)
            expect(json_response['error']).to eq('Validation failed: Value is not a number')
          end
        end
      end

      context 'missing params' do
        context 'name' do
          before { post '/api/metrics', params: { value: 1 } }

          it 'returns a failure response' do
            expect(response).to have_http_status(:bad_request)
          end

          it 'returns an error message' do
            json_response = JSON.parse(response.body)
            expect(json_response['error']).to eq("Validation failed: Name can't be blank")
          end
        end

        context 'value' do
          before { post '/api/metrics', params: { name: 'name' } }

          it 'returns a failure response' do
            expect(response).to have_http_status(:bad_request)
          end

          it 'returns an error message' do
            json_response = JSON.parse(response.body)
            expect(json_response['error']).to eq("Validation failed: Value can't be blank, Value is not a number")
          end
        end
      end
    end
  end

  describe 'GET #list' do
    context 'success' do
      context 'day' do
        let(:timestamp) { Time.zone.today }
        let!(:metrics) { create_list_metrics(timestamp:, per: 'day')[0] }

        before { get '/api/metrics/list', params: { timestamp:, per: 'day' } }

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns a list of metrics' do
          json_response = JSON.parse(response.body)
          expect(json_response.size).to eq(metrics.size)
          expect(json_response.map { |metric| metric['name'] }).to eq(metrics.map(&:name))
          expect(json_response.map { |metric| metric['value'] }).to eq(metrics.map(&:value))
          expect(json_response.map { |metric| DateTime.parse(metric['timestamp']) }).to eq(metrics.map(&:timestamp).map(&:to_datetime))
        end
      end

      context 'hour' do
        let(:timestamp) { Time.zone.today.to_datetime.change(hour: 9, min: 0) }
        let!(:metrics) { create_list_metrics(timestamp:, per: 'hour')[0] }

        before { get '/api/metrics/list', params: { timestamp:, per: 'hour' } }

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns a list of metrics' do
          datetime_format = '%Y-%m-%d %H:00:00'
          json_response = JSON.parse(response.body)
          expect(json_response.size).to eq(metrics.size)
          expect(json_response.map { |metric| metric['name'] }).to eq(metrics.map(&:name))
          expect(json_response.map { |metric| metric['value'] }).to eq(metrics.map(&:value))
          json_response.map do |metric|
            expect(DateTime.parse(metric['timestamp']).strftime(datetime_format)).to eq(timestamp.strftime(datetime_format))
          end
        end
      end

      context 'minute' do
        let(:timestamp) { Time.zone.today.to_datetime.change(hour: 9, min: 29, sec: 0) }
        let!(:metrics) { create_list_metrics(timestamp:, per: 'minute')[0] }

        before { get '/api/metrics/list', params: { timestamp:, per: 'minute' } }

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
        end

        it 'returns a list of metrics' do
          datetime_format = '%Y-%m-%d %H:%M:00'
          json_response = JSON.parse(response.body)
          expect(json_response.size).to eq(metrics.size)
          expect(json_response.map { |metric| metric['name'] }).to eq(metrics.map(&:name))
          expect(json_response.map { |metric| metric['value'] }).to eq(metrics.map(&:value))
          json_response.map do |metric|
            expect(DateTime.parse(metric['timestamp']).strftime(datetime_format)).to eq(timestamp.strftime(datetime_format))
          end
        end
      end
    end

    context 'failure' do
      context 'missing period' do
        let(:timestamp) { Time.zone.today }

        before { get '/api/metrics/list', params: { timestamp: } }

        it 'returns a invalid response' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error message' do
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq('Period is required')
        end
      end

      context 'missing timestamp' do
        before { get '/api/metrics/list', params: { per: 'day' } }

        it 'returns a invalid response' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error message' do
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq('Timestamp is required')
        end
      end

      context 'invalid period' do
        let(:timestamp) { Time.zone.today }

        before { get '/api/metrics/list', params: { timestamp:, per: 'week' } }

        it 'returns a invalid response' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'returns an error message' do
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to start_with('Period must be one of')
        end
      end
    end
  end
end
