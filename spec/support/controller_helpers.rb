# frozen_string_literal: true

def login(user = FactoryBot.create(:user))
  @logged_user = user
  request.headers.merge! @logged_user.create_new_auth_token
  end


def login_user_for_each_test
  before(:each) do
    login
  end
end

def json_response_body
  JSON.parse(response.body).with_indifferent_access
end
