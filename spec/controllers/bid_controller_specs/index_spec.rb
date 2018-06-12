# frozen_string_literal: true

require "rails_helper"

RSpec.describe BidsController, type: :controller do

  before do
    @user = FactoryBot.create(:user)
    @lot = FactoryBot.create(:lot, :with_in_process_status, user: @user)
    @another_user = FactoryBot.create(:user)
  end

  describe "GET #index" do
    include_examples "check on auth", "get", :index, params: { lot_id: 1 }

    describe "result after sign in" do
      include_examples "success response"

      before do
        @bid = FactoryBot.create(:bid, lot: @lot, user: @another_user)
        login @another_user
        get :index, params: { lot_id: @lot.id }
      end

      it "should have responce with equal params " do
        serializer = BidSerializer.new(@bid, current_user_id: @another_user.id)
        serialization = ActiveModelSerializers::Adapter.create(serializer)
        expect(JSON.parse(serialization.to_json)["bid"]).to eq(json_response_body["bids"][0])
      end

      it "should have encrypt user" do
        serializer = BidSerializer.new(@bid, current_user_id: @another_user.id)
        expect(serializer.customer_name).to eq(json_response_body["bids"][0]["customer_name"])
        expect("You").to eq(json_response_body["bids"][0]["customer_name"])
      end
      describe "lot not found " do
        include_examples "not found"
        before do
          get :index, params: { lot_id: 17 }
        end
      end
    end
  end
end
