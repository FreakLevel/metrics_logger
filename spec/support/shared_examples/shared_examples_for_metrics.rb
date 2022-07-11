# frozen_string_literal: true

RSpec.shared_examples 'metrics_controller_index' do
  it 'returns a success response' do
    expect(response).to be_successful
  end

  it 'returns metrics' do
    json_response = JSON.parse(response.body)
    expect(json_response['legend']).to eq expected_response[:legend]
    expect(json_response['labels']).to eq(expected_response[:labels])
    expect(json_response['data']).to eq(expected_response[:data])
  end
end
