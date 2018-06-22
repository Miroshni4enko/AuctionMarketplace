# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  include ActiveJob::TestHelper
  describe "Post #send" do
    include_examples "check on auth", "post", :_send_, params: { lot_id: 1 }

    describe "result after sign in" do
      let!(:user) { create(:user) }
      let!(:bid_user) { create(:user) }
      let!(:purchased_lot) do
        lot = create(:lot, :with_in_process_status, user: user)
        bid = create(:bid, lot: lot, user: bid_user)
        attrs = { winning_bid: bid.id, winner: bid_user.id, status: :closed }
        lot.update_columns attrs
        lot
      end
      let!(:new_order) { create(:order, lot: purchased_lot) }

      describe "sending of pending order" do
        before do
          login user
          perform_enqueued_jobs do
            post :_send_, params: { lot_id: purchased_lot.id }
          end
          new_order.reload
        end

        include_examples "success response"

        it "should change params " do
          expect(new_order.status).to eq("sent")
        end

        it "should send email to customer" do
          customer_email = ActionMailer::Base.deliveries.last
          customer_email_subject = "Order for  '#{purchased_lot.title}' lot was sent"
          expect(customer_email.subject).to eq(customer_email_subject)
          expect(customer_email.from).to eq(default_from_email)
          expect(customer_email.to).to eq([bid_user.email])
        end

      end
    end
  end
end
