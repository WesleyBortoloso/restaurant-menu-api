module V1
  class Menus < Grape::API
    resource :menus do

      desc 'List all menus'
      get do
        menus = Menu.all
        MenuSerializer.new(menus).serializable_hash
      end

      desc 'Show menu details'
      params do
        requires :id, type: Integer, desc: 'Menu ID'
      end
      get ':id' do
        menu = Menu.find(params[:id])
        MenuSerializer.new(menu).serializable_hash
      end

      desc 'List all menu items for a menu'
      params do
        requires :menu_id, type: Integer, desc: 'Menu ID'
      end
      get ':menu_id/menu_items' do
        menu = Menu.find(params[:menu_id])
        items = menu.menu_items
        MenuItemSerializer.new(items, include: [:pricings]).serializable_hash
      end
    end
  end
end
