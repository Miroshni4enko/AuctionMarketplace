# frozen_string_literal: true

require "rails_helper"

describe "Session user flow", type: :request do
  before (:each) do
     @user = FactoryBot.create(:user)
   end

  it "should sign in and get access-token" do
    post "/api/auth/sign_in", params: { email: @user.email, password: @user.password }
    expect(response).to be_successful
    expect(controller.current_user).to eq(@user)

    get user_members_only_path, headers: controller.headers
    expect(response).to be_successful
    expect(response.header["access-token"]).to be
    expect(controller.current_user).to eq(@user)
  end

  it "should sign out and delete access-token" do
    post "/api/auth/sign_in", params: { email: @user.email, password: @user.password }
    expect(response).to be_successful
    expect(controller.current_user).to eq(@user)

    delete "/api/auth/sign_out", headers: controller.headers
    expect(response).to be_successful
    expect(response.header["access-token"]).to eq nil
    expect(controller.current_user).to be_nil
  end
end
