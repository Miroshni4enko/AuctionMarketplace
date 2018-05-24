# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  scope :api do
    get "user/members_only", to: "user#members_only"
    mount_devise_token_auth_for "User", at: "auth", defaults: { format: :json }

    resources :lots, except: :index
    get "/lots/my", to: "lots#my"
    get "/lots/index/:criteria", to: "lots#index"

    mount Sidekiq::Web, at: "/sidekiq"
  end
end
