# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotsController, type: :controller do
  describe "GET #index by criteria " do
    describe "result without sign in" do
      it "doesn't give you anything if you don't log in" do
        get :index, params: { criteria: :all }
        expect(response).to have_http_status(401)
      end
    end
    describe "result with sign in" do
      before :all do
        @current_user = FactoryBot.create(:user)
        another_user = FactoryBot.create(:user)
        10.times do
          FactoryBot.create(:lot, user: @current_user)
          another_user_lot = FactoryBot.create(:lot, user: another_user)
          FactoryBot.create(:bid, lot: another_user_lot, user: @current_user)
        end
      end
      describe " by created criteria" do
        include_examples "lots_pagination"
        include_examples "success response"

        before :each do
          request.headers.merge! @current_user.create_new_auth_token
          get :index, params: { criteria: :created }
        end

        it "get only current users lots that user create for sale" do
          @current_user.reload
          response_lot_ids = json_response_body["lots"].map { |lot_hash| lot_hash["id"] }
          expect(@current_user.lots.map(&:id)).to match_array(response_lot_ids)
        end

        it "get only lots that user create for sale" do
          response_lot_ids = json_response_body["lots"].map { |lot_hash| lot_hash["id"] }
          expect(@current_user.lots.map(&:id)).to match_array(response_lot_ids)
        end
      end

      describe " by participation criteria" do
        include_examples "lots_pagination"
        include_examples "success response"
        before :each do
          request.headers.merge! @current_user.create_new_auth_token
          get :index, params: { criteria: :participation }
        end

        it "get only current users lots that user won/try to win" do
          @current_user.reload
          response_lot_ids = json_response_body["lots"].map { |lot_hash| lot_hash["id"] }
          expect(Lot.joins(:bids).where(bids: { user_id: @current_user.id }).map(&:id)).to match_array(response_lot_ids)
        end
      end

      describe "GET #index by all criteria" do
        include_examples "lots_pagination"
        include_examples "success response"
        before do
          current_user = FactoryBot.create(:user)
          request.headers.merge! current_user.create_new_auth_token
          get :index, params: { criteria: :all }
        end
      end
    end
  end

  def json_response_body
    JSON.parse(response.body)
  end
end
