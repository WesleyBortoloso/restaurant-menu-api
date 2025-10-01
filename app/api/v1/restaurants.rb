module V1
  class Restaurants < Grape::API
    resource :restaurants do

      desc 'List all restaurants'
      get do
        restaurants = Restaurant.all
        RestaurantSerializer.new(restaurants).serializable_hash
      end

      desc 'Show restaurant details'
      params do
        requires :id, type: Integer, desc: 'Restaurant ID'
      end
      get ':id' do
        restaurant = Restaurant.find(params[:id])
        RestaurantSerializer.new(restaurant).serializable_hash
      end
    end
  end
end
