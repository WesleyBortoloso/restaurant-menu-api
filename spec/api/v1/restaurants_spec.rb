require 'rails_helper'

RSpec.describe 'V1::Restaurants API', type: :request do
  let!(:restaurants) { create_list(:restaurant, 3) }
  let(:restaurant_id) { restaurants.first.id }

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
end
