require 'rails_helper'

RSpec.describe 'V1::Menus API', type: :request do
  let!(:menus) { create_list(:menu, 3) }
  let(:menu_id) { menus.first.id }
  let!(:menu_items) do
    create_list(:menu_item, 3).each { |item| menus.first.menu_items << item }
  end

  describe 'GET /api/v1/menus' do
    context 'when menus exist' do
      let!(:menus) { create_list(:menu, 3) }

      before { get '/api/v1/menus' }

      it 'returns all menus' do
        json = JSON.parse(response.body)
        expect(json['data'].size).to eq(3)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when no menus exist' do
      before { Menu.destroy_all; get '/api/v1/menus' }

      it 'returns an empty array' do
        json = JSON.parse(response.body)
        expect(json['data']).to eq([])
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'GET /api/v1/menus/:id' do
    context 'when the menu exists' do
      before { get "/api/v1/menus/#{menu_id}" }

      it 'returns the menu' do
        json = JSON.parse(response.body)
        expect(json['data']['id']).to eq(menu_id.to_s)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the menu does not exist' do
      before { get '/api/v1/menus/99999' }

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a JSON error message' do
        json = JSON.parse(response.body)
        expect(json['message']).to eq("Couldn't find Menu with 'id'=99999")
      end
    end
  end

  describe 'GET /api/v1/menus/:menu_id/menu_items' do
    context 'when menu exists and has menu items' do
      let(:menu) { menus.first }
      before { get "/api/v1/menus/#{menu.id}/menu_items" }

      it 'returns all menu items for the menu' do
        json = JSON.parse(response.body)
        expect(json['data'].first['id']).to eq(menu.menu_items.first.id.to_s)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when menu item does not exist' do
      before { get "/api/v1/menu_items/99999/menus" }

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
