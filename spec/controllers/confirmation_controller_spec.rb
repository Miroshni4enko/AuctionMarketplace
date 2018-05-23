# frozen_string_literal: true

require "rails_helper"

describe "Confirmation user before sign in", type: :request do

  before(:each) do
    @user = FactoryBot.create(:unconfirmed_user)
  end
  it "should restrict access to sign in without confirm" do
    post "/api/auth/sign_in", params: { email: @user.email, password: @user.password }
    expect(response).to have_http_status(401)
  end

  it "should allow to sign in with confirm" do
    @user.confirm
    post "/api/auth/sign_in", params: { email: @user.email, password: @user.password }
    expect(response).to have_http_status(200)
  end

  describe "GET #show " do
    it "redirect to redirect_url after confirmation" do
      @user = FactoryBot.build(:unconfirmed_user)
      @redirect_url = Faker::Internet.url
      @user.send_confirmation_instructions(redirect_url: @redirect_url)
      mail = ActionMailer::Base.deliveries.last
      token = mail.body.match(/confirmation_token=([^&]*)&/)[1]
      get "/api/auth/confirmation", params: { confirmation_token: token, redirect_url: @redirect_url }, headers: @user.create_new_auth_token
      expect(response["location"].split("?").first).to eq(@redirect_url)
    end
  end
end
