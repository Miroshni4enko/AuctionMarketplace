# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id               :bigint(8)        not null, primary key
#  arrival_location :text             not null
#  arrival_type     :integer          default("pickup"), not null
#  status           :integer          default("pending"), not null
#  lot_id           :bigint(8)
#
# Indexes
#
#  index_orders_on_lot_id  (lot_id)
#

require "rails_helper"
RSpec.describe Order, type: :model do

  describe "validation created  status" do
    it "must be pending after create" do
      pending_order = build(:order)
      sent_order = build(:order, status: :sent)
      delivered_order = build(:order, status: :delivered)

      pending_order.valid?
      sent_order.valid?
      delivered_order.valid?

      expect(pending_order.errors[:status]).to be_empty
      expect(sent_order.errors[:status]).to include ("must be pending")
      expect(delivered_order.errors[:status]).to include ("must be pending")
    end
  end

  describe "validation before updated " do

    let!(:user) {create(:user)}
    let!(:another_user) {create(:user)}
    let!(:lot) {create(:lot, :with_in_process_status, user: user)}
    let!(:bid) {create(:bid, lot: lot, user: another_user)}

    context "with sent status" do
      it_should_behave_like "sent order before update validation" do
        let(:order) {create(:order, :with_sent_status, lot: lot)}
      end

      it "should accept update status to delivered " do
        order = create(:order, :with_sent_status, lot: lot)
        order.update(status: :delivered)
        expect(order.errors[:status]).to be_empty
      end
    end

    context "with delivered status" do
      include_examples "sent order before update validation" do
        let(:order) {create(:order, :with_delivered_status, lot: lot)}
      end

      it "restrict update status to sent" do
        order = create(:order, :with_delivered_status, lot: lot)
        order.update(status: :sent)
        expect(order.errors[:status]).to include(error_status_changes)
      end
    end

    context "with pending status" do
      it "should accept any update" do
        order = create(:order, lot: lot)
        order.update(arrival_location: "some address", arrival_type: "pickup")
        expect(order.errors[:status]).to be_empty
      end
    end
  end

  def error_status_changes
    "status should be update only from pending to sent or from sent to delivered"
  end

  def error_order_validation
    "can't update order if status is not pending"
  end
end
