module V1
  class MenuItems < Grape::API
    resource :menu_items do

      desc 'List all menu items'
      get do
        menu_items = MenuItem.all
        MenuItemSerializer.new(menu_items).serializable_hash
      end

      desc 'Show a menu item'
      params do
        requires :id, type: Integer
      end
      get ':id' do
        item = MenuItem.find(params[:id])
        MenuItemSerializer.new(item).serializable_hash
      end

      desc 'List all menus for a menu item'
      params do
        requires :menu_id, type: Integer, desc: 'Menu ID'
      end
      get ':menu_id/menus' do
        menu_item = MenuItem.find(params[:menu_id])
        menus = menu_item.menus
        MenuSerializer.new(menus).serializable_hash
      end
    end
  end
end
