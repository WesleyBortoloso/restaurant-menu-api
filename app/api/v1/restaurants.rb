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

      desc 'Import restaurants data from external JSON file'
      params do
        requires :file, type: File, desc: 'JSON file to import'
      end
      post '/import' do
        file = params[:file]

        unless file[:type] == 'application/json'
          error!({ success: false, message: "Invalid file type, only JSON allowed" }, 415)
        end

        result = ::RestaurantImporter.new(file[:tempfile]).call

        if result[:success]
          present result
        else
          error!(result, 422)
        end
      end
    end
  end
end
