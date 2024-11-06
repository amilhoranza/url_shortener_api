# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :urls, only: %i[create show]
      get 'top_urls', to: 'urls#top'
    end
  end
  get '/:short_code', to: 'redirect#show', as: :short
end
