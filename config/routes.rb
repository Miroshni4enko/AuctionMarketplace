# frozen_string_literal: true

Rails.application.routes.draw do
  scope :api do
    get "user/members_only", to: "user#members_only"
    mount_devise_token_auth_for "User", at: "auth", defaults: { format: :json }

    resources :lots
    get '/lots/my', to: 'lots#my'
  end
end

