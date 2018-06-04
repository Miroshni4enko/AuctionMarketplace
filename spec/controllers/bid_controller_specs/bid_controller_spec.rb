# frozen_string_literal: true

require "rails_helper"

RSpec.describe BidsController, type: :controller do

  before do
    @current_user = FactoryBot.create(:user)
    @lot = FactoryBot.create(:lot, :with_in_process_status, user: @current_user)
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
          request.headers.merge! @another_user.create_new_auth_token
          post :create, params: @bid_params.merge(lot_id: @lot.id)
        end

        it "should add bid" do
          expect(@lot.bids.count).to eq(1)
        end
      end

      describe "create bids from the same user that created lot user" do
        before do
          request.headers.merge! @current_user.create_new_auth_token
          post :create, params: @bid_params.merge(lot_id: @lot.id)
        end
        it "should response forbidden status " do
          expect(response).to have_http_status(:forbidden)
        end
      end

      describe "create bids with unprocessable proposed price" do
        before do
          request.headers.merge! @another_user.create_new_auth_token
          post :create, params: { proposed_price: :not_exist, lot_id: @lot.id }
        end
        it "should response forbidden status " do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "GET #index" do
    include_examples "check on auth", "get", :index, params: { lot_id: 1 }

    describe "result after sign in" do
      include_examples "success response"
      before do
        @bid = FactoryBot.create(:bid, lot: @lot, user: @another_user)
        request.headers.merge! @another_user.create_new_auth_token
        get :index, params: { lot_id: @lot.id  }
      end

      it "should have responce with equal params " do
        @serializer = BidSerializer.new(@bid, current_user_id: @another_user.id)
        @serialization = ActiveModelSerializers::Adapter.create(@serializer)
        expect(JSON.parse(@serialization.to_json)["bid"]).to eq(json_response_body["bids"][0])
      end

      it "should have encrypt user" do
        @serializer = BidSerializer.new(@bid, current_user_id: @another_user.id)
        expect(@serializer.customer_name).to eq(json_response_body["bids"][0]["customer_name"])
        expect("You").to eq(json_response_body["bids"][0]["customer_name"])
      end

    end
  end

  def json_response_body
    JSON.parse(response.body)
  end
end
