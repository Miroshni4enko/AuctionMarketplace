# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrdersController, type: :controller do

  describe "Put #update" do
    include_examples "check on auth", "put", :update, params: { id: 1, lot_id: 1 }


    let!(:user) { create(:user) }
    let!(:bid_user) { create(:user) }
    let!(:purchased_lot) do
      lot = create(:lot, :with_in_process_status, user: user)
      bid = create(:bid, lot: lot, user: bid_user)
      attrs = { winning_bid: bid.id, winner: bid_user.id, status: :closed }
      lot.update_columns attrs
      lot
    end
    let(:new_order) { create(:order, lot: purchased_lot) }
    let(:new_params) { { arrival_type: "pickup", arrival_location: "some new location" } }


    describe "result after sign in" do

      describe "update pending order" do
        before do
          login bid_user
          put :update, params: new_params.merge(id: new_order.id, lot_id: purchased_lot.id)
          new_order.reload
        end

        include_examples "success response"

        it "should change params " do
          expect(new_order.arrival_type).to eq(new_params[:arrival_type])
          expect(new_order.arrival_location).to eq(new_params[:arrival_location])
        end

      end
    end

    describe " update another user order" do
      before do
        login user
        put :update, params: new_params.merge!(id: new_order.id, lot_id: purchased_lot.id)
      end

      include_examples "forbidden response"
    end
  end
end
