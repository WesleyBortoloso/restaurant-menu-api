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
    end
  end
end
