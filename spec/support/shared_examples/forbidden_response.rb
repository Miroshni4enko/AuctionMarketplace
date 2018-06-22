
# frozen_string_literal: true

RSpec.shared_examples "forbidden response" do
  it "get forbidden result" do
    expect(response).to be_forbidden
  end
end
