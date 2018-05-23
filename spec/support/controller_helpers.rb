# frozen_string_literal: true

module ControllerHelpers
  def login_user
    user = FactoryBot.create(:user)
    sign_in user
    request.headers.merge! user.create_new_auth_token
  end
  def login_user_for_each_test
    before(:each) do
      login_user
    end
  end
end
