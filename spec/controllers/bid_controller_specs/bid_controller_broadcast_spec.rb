# frozen_string_literal: true

require "rails_helper"
require "sidekiq/testing"

RSpec.describe BidsController, type: :controller do
  include_examples "success response"
  describe "POST #create" do
    before do
      @current_user = FactoryBot.create(:user)
      @lot = FactoryBot.create(:lot, :with_in_process_status, user: @current_user)
      @another_user = FactoryBot.create(:user)
      @bid_params = FactoryBot.attributes_for(:bid, :with_created_at, :with_id, lot: @lot, user: @another_user)
    end
    it "should broadcast bid" do
      Sidekiq::Testing.inline! do
        request.headers.merge! @another_user.create_new_auth_token
        @bid = Bid.new(@bid_params) #= {lot_id: @lot.id, user_id: @another_user.id}.merge(@bid_params)
        serializer = BidSerializer.new(@bid)
        serialization = ActiveModelSerializers::Adapter.create(serializer)
        expect { post :create, params: @bid_params.merge!(lot_id: @lot.id) }.to have_broadcasted_to("bids_for_lot_#{@lot.id}_channel").with(bid: serialization.to_json)
      end
    end
  end
end
