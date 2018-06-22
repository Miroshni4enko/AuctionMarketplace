# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  include ActiveJob::TestHelper
  describe "Post #deliver" do
    include_examples "check on auth", "post", :deliver, params: { lot_id: 1 }

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
      let!(:new_order) { create(:order, :with_sent_status, lot: purchased_lot) }

      describe "delivering of sent order" do
        before { ActionMailer::Base.deliveries = [] }

        before do
          login bid_user
          perform_enqueued_jobs do
            post :deliver, params: { lot_id: purchased_lot.id }
          end
          new_order.reload
        end

        include_examples "success response"

        it "should change params " do
          expect(new_order.status).to eq("delivered")
        end

        it "should send email to seller and customer" do
          emails = ActionMailer::Base.deliveries
          seller_email_subject = "Order for  '#{purchased_lot.title}' lot was successfully delivered"
          seller_email = emails.find { |email| email.subject == seller_email_subject }

          customer_email_subject = "Confirmation for '#{purchased_lot.title}'"
          customer_email = emails.find { |email| email.subject == customer_email_subject }

          expect(default_from_email).to eq(seller_email.from)
          expect([user.email]).to eq(seller_email.to)

          expect(default_from_email).to eq(customer_email.from)
          expect([bid_user.email]).to eq(customer_email.to)
        end

      end
    end
  end
end
