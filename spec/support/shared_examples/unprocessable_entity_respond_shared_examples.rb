# frozen_string_literal: true

RSpec.shared_examples "unprocessable entity" do
  it " can't change another user lot" do
    expect(response).to be_unprocessable
  end
end
