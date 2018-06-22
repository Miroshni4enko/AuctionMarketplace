# frozen_string_literal: true

def login(user = create(:user))
  @logged_user = user
  request.headers.merge! @logged_user.create_new_auth_token
end


def login_user_for_each_test
  before(:each) do
    login
  end
end

def json_response_body(response_value = response)
  JSON.parse(response_value.body).with_indifferent_access
end

def default_from_email
  ["from@example.com"]
end
