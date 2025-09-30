Rails.application.routes.draw do
  mount Base => '/'

  get "up" => "rails/health#show", as: :rails_health_check
end