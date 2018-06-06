# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  scope :api do
    mount_devise_token_auth_for "User", at: "auth", defaults: { format: :json }


    get "/lots/my/:filter", to: "lots#my"
    resources :lots do
      resources :bids, except: [:show, :update, :destroy]
    end

    mount Sidekiq::Web, at: "/sidekiq"
    mount ActionCable.server => "/cable"
  end
end
