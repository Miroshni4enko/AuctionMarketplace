# frozen_string_literal: true

RSpec.shared_examples "unprocessable entity" do
  it " can't change with unprocessable params" do
    expect(response).to be_unprocessable
  end
end
