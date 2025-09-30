class Base < Grape::API
  prefix 'api'
  format :json
  
  mount V1::Base

  rescue_from ActiveRecord::RecordNotFound do |e|
    error!({ message: e.message }, 404)
  end

  rescue_from :all do |e|
    error!({ message: e.message }, 500)
  end

  add_swagger_documentation
end
