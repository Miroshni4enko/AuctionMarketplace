# frozen_string_literal: true

RSpec.shared_examples "sent order before update validation" do

  it "should restrict update arrival_type" do
    order.update(arrival_type: "pickup")
    expect(order.errors[:status]).to include(error_order_validation)
  end

  it "should restrict update arrival_location" do
    order.update(arrival_location: "some address")
    expect(order.errors[:status]).to include(error_order_validation)
  end

  it "restrict update status to pending " do
    order.update(status: :pending)
    expect(order.errors[:status]).to include(error_status_changes)
  end
end
