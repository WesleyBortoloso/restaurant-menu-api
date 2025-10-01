require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe 'associations' do
    it { should have_many(:menu_menu_items).dependent(:destroy) }
    it { should have_many(:menus).through(:menu_menu_items) }
  end

  describe 'validations' do
    subject { build(:menu_item) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'custom scenarios' do
    let(:restaurant1) { create(:restaurant) }
    let(:restaurant2) { create(:restaurant) }
    let(:menu1) { create(:menu, restaurant: restaurant1) }
    let(:menu2) { create(:menu, restaurant: restaurant2) }

    it 'is valid with valid attributes' do
      menu_item = MenuItem.new(name: 'Pizza', price: 20.0)
      expect(menu_item).to be_valid
    end

    it 'is invalid without a name' do
      menu_item = MenuItem.new(name: nil, price: 20.0)
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a price' do
      menu_item = MenuItem.new(name: 'Pizza', price: nil)
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:price]).to include("can't be blank")
    end

    it 'is invalid with a negative price' do
      menu_item = MenuItem.new(name: 'Pizza', price: -5)
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:price]).to include("must be greater than or equal to 0")
    end

    it 'is invalid if associated menus belong to different restaurants' do
      menu_item = create(:menu_item)
      menu_item.menus << menu1
      menu_item.menus << menu2
      menu_item.valid?
      expect(menu_item.errors[:menus]).to include("must belong to the same restaurant")
    end

    it 'is valid if all associated menus belong to the same restaurant' do
      menu_item = create(:menu_item)
      menu_item.menus << menu1
      another_menu = create(:menu, restaurant: restaurant1)
      menu_item.menus << another_menu
      expect(menu_item).to be_valid
      expect(menu_item.errors[:menus]).to be_empty
    end
  end
end
