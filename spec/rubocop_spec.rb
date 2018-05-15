# frozen_string_literal: true

describe "Rubocop" do
  it "should execute without offenses" do
    expect(system("rubocop")).to eq(true)
  end
end
