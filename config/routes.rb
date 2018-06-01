# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  scope :api do
    get "user/members_only", to: "user#members_only"
    mount_devise_token_auth_for "User", at: "auth", defaults: { format: :json }


    get "/lots/my/:filter", to: "lots#my"
    resources :lots do
      resources :bids, except: [:show, :update, :destroy]
    end

    mount Sidekiq::Web, at: "/sidekiq"
  end
end
