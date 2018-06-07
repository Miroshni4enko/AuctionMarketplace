# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  get "/api" => redirect("/swagger-ui/dist/index.html?url=/apidocs/api-docs.json")
  scope :api do
    mount_devise_token_auth_for "User", at: "auth", defaults: { format: :json }, controllers: {
        sessions: "users/sessions",
        registrations: "users/registrations",
        token_validations: "users/token_validations",
        passwords: "users/passwords",
        confirmations: "users/confirmations"
    }


    get "/lots/my/:filter", to: "lots#my"
    resources :lots do
      resources :bids, except: [:show, :update, :destroy]
    end

    mount Sidekiq::Web, at: "/sidekiq"
    mount ActionCable.server => "/cable"
  end
end
