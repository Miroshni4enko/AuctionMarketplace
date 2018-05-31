# frozen_string_literal: true

RSpec.shared_examples "success response" do
  it "get success result after sign_in" do
    expect(response).to be_successful
  end
end
