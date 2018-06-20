# frozen_string_literal: true

require "rails_helper"

RSpec.describe MyController, type: :controller do

  describe "GET #my by criteria " do
    include_examples "check on auth", "get", :index, params: { filter: :all }

    describe "result with sign in" do
      before :all do
        @user = FactoryBot.create(:user)
        another_user = FactoryBot.create(:user)
        FactoryBot.create_list(:lot, 10, :with_in_process_status, user: @user)
        @another_user_lot = FactoryBot.create(:lot, :with_in_process_status, user: another_user)
        FactoryBot.create_list(:bid, 10, lot: @another_user_lot, user: @user)
      end

      describe " by created criteria" do
        include_examples "lots_pagination"
        include_examples "success response"

        before :each do
          login @user
          get :index, params: { filter: :created }
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
          get :index, params: { filter: :participation }
        end

        it "get only current users lots that user won/try to win" do
          @user.reload
          response_lot_ids = json_response_body["lots"].map { |lot_hash| lot_hash["id"] }
          expect([@another_user_lot.id]).to match_array(response_lot_ids)
        end
      end

      describe "GET #my by all criteria" do
        include_examples "lots_pagination"
        include_examples "success response"

        before do
          login
          another_user = FactoryBot.create(:user)
          FactoryBot.create_list(:lot, 10, :with_in_process_status, user: @logged_user)
          FactoryBot.create_list(:lot, 10, :with_in_process_status, user: another_user)

          get :index, params: { filter: :all }

          @response_lot_ids = json_response_body["lots"].map { |lot_hash| lot_hash["id"] }
        end

        it "gets only current user lots" do
          @logged_user.reload
          expect(@logged_user.lots.map(&:id)).to match_array(@response_lot_ids)
        end

        it "has only 10 lots" do
          expect(@response_lot_ids.size).to eq(10)
        end
      end
    end
  end
end
