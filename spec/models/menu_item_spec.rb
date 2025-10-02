require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  describe 'associations' do
    it { should have_many(:pricings).dependent(:destroy) }
    it { should have_many(:menus).through(:pricings) }
    it { should belong_to(:restaurant)}
  end

  describe 'validations' do
    subject { build(:menu_item) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:restaurant_id) }
  end

  describe 'custom scenarios' do
    let(:restaurant1) { create(:restaurant) }
    let(:restaurant2) { create(:restaurant) }
    let(:menu1) { create(:menu, restaurant: restaurant1) }
    let(:menu2) { create(:menu, restaurant: restaurant2) }

    it 'is valid with valid attributes' do
      menu_item = MenuItem.new(name: 'Pizza', restaurant: restaurant1)
      expect(menu_item).to be_valid
    end

    it 'is invalid without a name' do
      menu_item = MenuItem.new(name: nil, restaurant: restaurant1)
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:name]).to include("can't be blank")
    end
  end
end
