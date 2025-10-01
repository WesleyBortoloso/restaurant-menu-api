require 'rails_helper'

RSpec.describe 'V1::MenuItems API', type: :request do
  let!(:menu) { create(:menu) }
  let!(:menu_items) do
    create_list(:menu_item, 3).each { |item| menu.menu_items << item }
  end

  describe 'GET /api/v1/menu_items' do
    context 'when exists menu items' do
      before { get "/api/v1/menu_items" }

      it 'returns all menu items' do
        json = JSON.parse(response.body)
        expect(json['data'].size).to eq(3)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when no menu items exists' do
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

  describe 'GET /api/v1/menu_items/:id' do
    context 'when menu item exists' do
      let(:item) { menu_items.first }
      before { get "/api/v1/menu_items/#{item.id}" }

      it 'returns the menu item' do
        json = JSON.parse(response.body)
        expect(json['data']['id']).to eq(item.id.to_s)
        expect(json['data']['attributes']['name']).to eq(item.name)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when menu item does not exist' do
      before { get "/api/v1/menu_items/99999" }

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET /api/v1/menu_items/:menu_item_id/menus' do
    context 'when menu item exists and has menus' do
      let(:item) { menu_items.first }
      before { get "/api/v1/menu_items/#{item.id}/menus" }

      it 'returns all menus for the menu item' do
        json = JSON.parse(response.body)
        expect(json['data'].first['id']).to eq(menu.id.to_s)
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
