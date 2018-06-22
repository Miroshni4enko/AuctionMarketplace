# frozen_string_literal: true

RSpec.shared_examples "sent order before update validation" do
  let(:error_for_update) { "can't update order if status is not pending" }
  let(:error_for_reverse_status) { "status should be update only from pending to sent or from sent to delivered" }

  it "should restrict update arrival_type" do
    order.update(arrival_type: "pickup")
    expect(order.errors[:status]).to include(error_for_update)
  end

  it "should restrict update arrival_location" do
    order.update(arrival_location: "some address")
    expect(order.errors[:status]).to include(error_for_update)
  end

  it "restrict update status to pending " do
    order.update(status: :pending)
    expect(order.errors[:status]).to include(error_for_reverse_status)
  end
end
