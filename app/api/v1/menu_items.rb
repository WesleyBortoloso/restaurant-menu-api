module V1
  class MenuItems < Grape::API
    resource :menu_items do

      desc 'List menu items for a menu'
      params do
        requires :menu_id, type: Integer, desc: 'Menu ID'
      end
      get do
        menu = Menu.find(params[:menu_id])
        items = menu.menu_items
        MenuItemSerializer.new(items).serializable_hash
      end
    end
  end
end
