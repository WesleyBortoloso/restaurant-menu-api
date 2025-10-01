module V1
  class Base < Grape::API
    version 'v1', using: :path
    format :json

    mount V1::Menus
    mount V1::MenuItems
    mount V1::Restaurants

    add_swagger_documentation \
      api_version: 'v1',
      base_path: '/',
      mount_path: '/swagger_doc',
      hide_documentation_path: true,
      info: {
        title: 'Restaurant Menu API',
        description: 'API for Restaurant Menus',
        contact_name: 'Wesley Bortoloso'
      }
  end
end
