# frozen_string_literal: true

require "rails_helper"

RSpec.describe BidsController, type: :controller do

  before do
    @user = FactoryBot.create(:user)
    @lot = FactoryBot.create(:lot, :with_in_process_status, user: @user)
    @another_user = FactoryBot.create(:user)
  end

  describe "post #create" do
    include_examples "check on auth", "post", :create, params: { lot_id: 1, proposed_price: 1 }

    before do
      @bid_params = FactoryBot.attributes_for(:bid, lot: @lot, user: @another_user)
    end

    describe "result after sign in" do
      describe "create bids from diff user than created lot user" do
        include_examples "success response"

        before do
          login @another_user
          post :create, params: @bid_params.merge(lot_id: @lot.id)
        end

        it "should add bid" do
          expect(@lot.bids.count).to eq(1)
        end
      end

      describe "create bids from the same user that created lot user" do

        before do
          login  @user
          post :create, params: @bid_params.merge(lot_id: @lot.id)
        end

        it "should response forbidden status " do
          expect(response).to have_http_status(:forbidden)
        end
      end

      describe "create bids with unprocessable proposed price" do

        before do
          login @another_user
          post :create, params: { proposed_price: :not_exist, lot_id: @lot.id }
        end

        it "should response forbidden status " do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
