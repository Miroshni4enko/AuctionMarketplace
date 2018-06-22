# frozen_string_literal: true

RSpec.shared_examples "mailers" do
  it "should send email with appropriate params" do
    expect(ActionMailer::Base.deliveries).to be
    expect(["from@example.com"]).to eq(email.from)
    expect([user.email]).to eq(email.to)
    expect(subject).to eq(email.subject)
  end
end
