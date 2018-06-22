# frozen_string_literal: true

RSpec.shared_examples "not found" do
  it "should response not found if item doesn't exist" do
    expect(response).to be_not_found
  end
end
