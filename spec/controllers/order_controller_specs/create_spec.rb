# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  include ActiveJob::TestHelper

  let!(:user) { create(:user) }
  let!(:bid_user) { create(:user) }

  let!(:purchased_lot) do
    lot = create(:lot, :with_in_process_status, user: user)
    bid = create(:bid, lot: lot, user: bid_user)
    attrs = { winning_bid: bid.id, winner: bid_user.id, status: :closed }
    lot.update_columns attrs
    lot
  end
  let(:order_params) { attributes_for(:order, lot: purchased_lot) }

  describe "post #create" do
    fake_params = { lot_id: -1, arrival_type: "pickup", arrival_location: "Some location" }

    include_examples "check on auth", "post", :create, params: fake_params

    describe "result after sign in" do
      describe "create oder from diff user than created lot user" do
        include_examples "success response"

        before { ActionMailer::Base.deliveries = [] }

        before do
          login bid_user
        end

        subject(:create_order) do
          perform_enqueued_jobs do
            post :create, params: order_params.merge(lot_id: purchased_lot.id)
          end
          response
        end

        it "should add order" do
          create_order
          expect(purchased_lot.order).to be
        end

        it "should send email to seller" do
          create_order
          seller_email = ActionMailer::Base.deliveries.last
          seller_email_subject = "Order for  '#{purchased_lot.title}' lot was created"
          expect(seller_email.subject).to eq(seller_email_subject)
          expect(seller_email.from).to eq(default_from_email)
          expect(seller_email.to).to eq([user.email])
        end

      end

      describe "create order with unprocessable params" do
        before do
          login bid_user
          post :create, params: { lot_id: purchased_lot.id }
        end
        include_examples "unprocessable entity"
      end

      describe "creating bid from different users" do
        context "with bid created user, should have success result if user who created winning bid" do
          before do
            login bid_user
            post :create, params: order_params.merge(lot_id: purchased_lot.id)
          end
          include_examples "success response"
        end

        context "with other user, should have forbidden result if user who NOT created winning bid" do
          before do
            login user
            post :create, params: order_params.merge(lot_id: purchased_lot.id)
          end
          include_examples "forbidden response"
        end
      end

      describe "bid not found " do
        before do
          login bid_user
          post :create, params: order_params.merge(lot_id: -17)
        end
        include_examples "not found"
      end
    end
  end
end
