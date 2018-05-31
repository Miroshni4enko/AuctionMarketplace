# frozen_string_literal: true

require "rails_helper"

RSpec.describe BidsController, type: :controller do
  describe "post #create" do
    include_examples "check on auth", "post", :create

    describe "result after sign in" do
      include_examples "success response"
      before do
        current_user = FactoryBot.create(:user)
        @lot = FactoryBot.create(:lot, :with_in_process_status, user: current_user)
        @bid_params = FactoryBot.attributes_for(:bid, lot: @lot, user: current_user)
        request.headers.merge! current_user.create_new_auth_token
        post :create, params: @bid_params.merge(lot_id: @lot.id)
      end

      it "should add lot" do
        expect(@lot.bids.count).to eq(1)
      end

    end

  end
end
