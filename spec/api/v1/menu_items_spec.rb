require 'rails_helper'

RSpec.describe 'V1::MenuItems API', type: :request do
  let!(:menu) { create(:menu) }
  let!(:menu_items) { create_list(:menu_item, 3, menu: menu) }

  describe 'GET /api/v1/menu_items' do
    context 'when menu exists with items' do
      before { get "/api/v1/menu_items", params: { menu_id: menu.id } }

      it 'returns all menu items for the menu' do
        json = JSON.parse(response.body)
        expect(json['data'].size).to eq(3)
        expect(json['data'].first['attributes']['name']).to eq(menu_items.first.name)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when menu exists but has no items' do
      let!(:empty_menu) { create(:menu) }

      before { get "/api/v1/menu_items", params: { menu_id: empty_menu.id } }

      it 'returns an empty array' do
        json = JSON.parse(response.body)
        expect(json['data']).to eq([])
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when menu does not exist' do
      before { get "/api/v1/menu_items", params: { menu_id: 99999 } }

      it 'returns status 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a JSON error message' do
        json = JSON.parse(response.body)
        expect(json['message']).to eq("Couldn't find Menu with 'id'=99999")
      end
    end
  end
end
