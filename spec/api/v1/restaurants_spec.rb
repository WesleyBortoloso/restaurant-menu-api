require 'rails_helper'
include ActionDispatch::TestProcess

RSpec.describe 'V1::Restaurants API', type: :request do
  let!(:restaurants) { create_list(:restaurant, 3) }
  let(:restaurant_id) { restaurants.first.id }
  let(:file) { fixture_file_upload('restaurant_data.json', 'application/json') }
  let(:importer) { instance_double(::RestaurantImporter) }

  before do
    allow(::RestaurantImporter).to receive(:new).and_return(importer)
  end

  describe 'GET /api/v1/restaurants' do
    context 'when restaurants exist' do
      before { get '/api/v1/restaurants' }

      it 'returns all restaurants' do
        json = JSON.parse(response.body)
        expect(json['data'].size).to eq(3)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when no restaurants exist' do
      before { Restaurant.destroy_all; get '/api/v1/restaurants' }

      it 'returns an empty array' do
        json = JSON.parse(response.body)
        expect(json['data']).to eq([])
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /api/v1/restaurants/:id' do
    context 'when the restaurant exists' do
      before { get "/api/v1/restaurants/#{restaurant_id}" }

      it 'returns the restaurant' do
        json = JSON.parse(response.body)
        expect(json['data']['id']).to eq(restaurant_id.to_s)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the restaurant does not exist' do
      before { get '/api/v1/restaurants/99999' }

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a JSON error message' do
        json = JSON.parse(response.body)
        expect(json['message']).to eq("Couldn't find Restaurant with 'id'=99999")
      end
    end
  end

  describe 'POST /api/v1/restaurants/import' do
    context 'when import is successful' do
      before do
        allow(importer).to receive(:call).and_return({ success: true, message: 'Import finished', logs: [] })
        post '/api/v1/restaurants/import', params: { file: file }
      end

      it 'calls the importer service' do
        expect(::RestaurantImporter).to have_received(:new).with(kind_of(Tempfile))
        expect(importer).to have_received(:call)
      end

      it 'returns success response' do
        json = JSON.parse(response.body)
        expect(json['success']).to be true
        expect(response).to have_http_status(200).or have_http_status(201)
      end
    end

    context 'when import fails' do
      before do
        allow(importer).to receive(:call).and_return({ success: false, message: 'Invalid JSON', logs: [] })
        post '/api/v1/restaurants/import', params: { file: file }
      end

      it 'returns error response' do
        json = JSON.parse(response.body)
        expect(json).to eq({ 'success' => false, 'message' => 'Invalid JSON', 'logs' => [] })
        expect(response).to have_http_status(422)
      end
    end

    context 'when file type is invalid' do
      let(:invalid_file) { fixture_file_upload('restaurant_data.json', 'text/plain') }

      it 'returns 415 unsupported media type' do
        post '/api/v1/restaurants/import', params: { file: invalid_file }

        json = JSON.parse(response.body)
        expect(json['success']).to be false
        expect(json['message']).to eq('Invalid file type, only JSON allowed')
        expect(response).to have_http_status(415)
      end
    end
  end
end
