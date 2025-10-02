require 'rails_helper'
include ActionDispatch::TestProcess

RSpec.describe RestaurantImporter, type: :service do
  let(:file) { fixture_file_upload('restaurant_data.json', 'application/json') }
  let(:importer) { described_class.new(file) }

  describe '#call' do
    context 'with valid JSON' do
      it 'creates restaurants, menus, menu_items and pricings' do
        expect { importer.call }.to change(Restaurant, :count).by(2)
                                   .and change(Menu, :count).by(4)
                                   .and change(MenuItem, :count).by(7)
                                   .and change(Pricing, :count).by(8)

        result = importer.call
        expect(result[:success]).to be true
        expect(result[:message]).to eq('Import finished')
        expect(result[:logs]).not_to be_empty
      end

      it 'sets correct pricing for menu items' do
        importer.call
        burger_lunch = MenuItem.find_by(name: 'Burger').pricings.find_by(menu: Menu.find_by(name: 'lunch'))
        burger_dinner = MenuItem.find_by(name: 'Burger').pricings.find_by(menu: Menu.find_by(name: 'dinner'))
        expect(burger_lunch.price).to eq(9)
        expect(burger_dinner.price).to eq(15)
      end
    end

    context 'with invalid JSON file' do
      let(:file) { StringIO.new('invalid json') }

      it 'returns failure result' do
        result = described_class.new(file).call
        expect(result[:success]).to be false
        expect(result[:message]).to eq('Invalid JSON data')
      end
    end

    context 'with invalid data structure' do
      let(:file) { StringIO.new({ foo: 'bar' }.to_json) }

      it 'returns failure result' do
        result = described_class.new(file).call
        expect(result[:success]).to be false
        expect(result[:message]).to eq('Invalid JSON data')
      end
    end

    context 'when a menu_item fails validation' do
      let(:file) do
        StringIO.new({
          restaurants: [
            {
              name: 'Test Restaurant',
              menus: [
                { name: 'Lunch', menu_items: [{ name: nil, price: 10 }] }
              ]
            }
          ]
        }.to_json)
      end

      it 'logs the failure and continues' do
        result = described_class.new(file).call
        expect(result[:success]).to be true
        expect(result[:logs].any? { |log| log[:status].include?('failed') }).to be true
      end
    end

    context 'when a StandardError occurs' do
      let(:file) { double(read: '{"restaurants": []}') }
      let(:importer) { RestaurantImporter.new(file) }

      before do
        allow(importer).to receive(:process_import_data!).and_raise(StandardError.new("StandardError"))
      end

      it 'returns an unexpected error result' do
        result = importer.call
        expect(result[:success]).to be false
        expect(result[:message]).to eq('Unexpected error')
      end
    end
  end
end
