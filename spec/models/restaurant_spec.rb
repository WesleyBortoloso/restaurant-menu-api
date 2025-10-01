require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'associations' do
    it { should have_many(:menus).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:restaurant) }

    it { should validate_presence_of(:name) }
  end

  describe 'custom scenarios' do
    it 'is valid with a name' do
      restaurant = build(:restaurant, name: "Poppo's Cafe")
      expect(restaurant).to be_valid
    end

    it 'is invalid without a name' do
      restaurant = build(:restaurant, name: nil)
      expect(restaurant).not_to be_valid
      expect(restaurant.errors[:name]).to include("can't be blank")
    end
  end
end
