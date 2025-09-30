require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe 'associations' do
    it { should belong_to(:menu) }
  end

  describe 'validations' do
    subject { build(:menu_item) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end

  describe 'custom scenarios' do
    let(:menu) { create(:menu) }

    it 'is valid with valid attributes' do
      menu_item = MenuItem.new(name: 'Pizza', price: 20.0, menu: menu)
      expect(menu_item).to be_valid
    end

    it 'is invalid without a name' do
      menu_item = MenuItem.new(name: nil, price: 20.0, menu: menu)
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a price' do
      menu_item = MenuItem.new(name: 'Pizza', price: nil, menu: menu)
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:price]).to include("can't be blank")
    end

    it 'is invalid with a negative price' do
      menu_item = MenuItem.new(name: 'Pizza', price: -5, menu: menu)
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:price]).to include("must be greater than or equal to 0")
    end
  end
end
