# frozen_string_literal: true

describe "Rubocop" do
  it "should execute without offenses" do
    expect(system("rubocop --auto-correct")).to eq(true)
  end
end
