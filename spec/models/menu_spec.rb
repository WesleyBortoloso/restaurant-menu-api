require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'associations' do
    it { should have_many(:menu_menu_items).dependent(:destroy) }
    it { should have_many(:menu_items).through(:menu_menu_items) }
    it { should belong_to(:restaurant) }
  end

  describe 'validations' do
    subject { build(:menu) }

    it { should validate_presence_of(:name) }
  end

  describe 'custom scenarios' do
    it 'is valid with a name' do
      menu = build(:menu, name: 'Lunch')
      expect(menu).to be_valid
    end

    it 'is invalid without a name' do
      menu = build(:menu, name: nil)
      expect(menu).not_to be_valid
      expect(menu.errors[:name]).to include("can't be blank")
    end
  end
end
