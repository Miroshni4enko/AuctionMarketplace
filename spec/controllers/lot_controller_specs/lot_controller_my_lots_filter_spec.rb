# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotsController, type: :controller do
  describe "GET #index by criteria " do
    include_examples "check on auth", "get", :my, params: { filter: :all }
    describe "result with sign in" do
      before :all do
        @user = FactoryBot.create(:user)
        another_user = FactoryBot.create(:user)
        10.times do
          FactoryBot.create(:lot, user: @user)
          another_user_lot = FactoryBot.create(:lot, user: another_user)
          FactoryBot.create(:bid, lot: another_user_lot, user: @user)
        end
      end
      describe " by created criteria" do
        include_examples "lots_pagination"
        include_examples "success response"

        before :each do
          login @user
          get :my, params: { filter: :created }
        end

        it "get only current users lots that user create for sale" do
          @user.reload
          response_lot_ids = json_response_body["lots"].map { |lot_hash| lot_hash["id"] }
          expect(@user.lots.map(&:id)).to match_array(response_lot_ids)
        end

        it "get only lots that user create for sale" do
          response_lot_ids = json_response_body["lots"].map { |lot_hash| lot_hash["id"] }
          expect(@user.lots.map(&:id)).to match_array(response_lot_ids)
        end
      end

      describe " by participation criteria" do
        include_examples "lots_pagination"
        include_examples "success response"
        before :each do
          login @user
          get :my, params: { filter: :participation }
        end

        it "get only current users lots that user won/try to win" do
          @user.reload
          response_lot_ids = json_response_body["lots"].map { |lot_hash| lot_hash["id"] }
          expect(Lot.joins(:bids).where(bids: { user_id: @user.id }).map(&:id)).to match_array(response_lot_ids)
        end
      end

      describe "GET #index by all criteria" do
        include_examples "lots_pagination"
        include_examples "success response"
        before do
          login
          another_user = FactoryBot.create(:user)
          10.times do
            FactoryBot.create(:lot, user: @user)
            FactoryBot.create(:lot, user: another_user)
          end


          get :my, params: { filter: :all }

          @response_lot_ids = json_response_body["lots"].map { |lot_hash| lot_hash["id"] }
        end

        it "gets only current user lots" do
          @user.reload
          expect(@user.lots.map(&:id)).to match_array(@response_lot_ids)
        end

        it "has only 10 lots" do
          expect(@response_lot_ids.size).to eq(10)
        end

      end
    end
  end
end
