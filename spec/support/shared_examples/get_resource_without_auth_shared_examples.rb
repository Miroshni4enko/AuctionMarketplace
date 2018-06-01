# frozen_string_literal: true

RSpec.shared_examples "check on auth" do |method, action, params = {}|
  it "doesn't give you anything if you don't log in" do
      send(method, action, params)
      expect(response).to have_http_status(401)
    end
end
