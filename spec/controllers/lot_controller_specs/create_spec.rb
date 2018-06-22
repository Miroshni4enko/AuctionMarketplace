# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotsController, type: :controller do

  describe "Post #create " do
    include_examples "check on auth", "post", :create

    describe "result after sign in" do

      login_user_for_each_test

      context "success" do
        include_examples "success response"

        before do
          new_lot_params = attributes_for(:lot, user: @user)
          post :create, params: new_lot_params
        end

        it "should add lot" do
          expect(@logged_user.lots.count).to eq(1)
        end

        it "should add two jobs" do
          expect(LotStatusUpdateWorker.jobs.size).to eq(2)
        end
      end

      context "fail" do
        include_examples "unprocessable entity"

        before do
          new_lot_params = attributes_for(:lot, estimated_price: -21.00, user: @user)
          post :create, params: new_lot_params
        end

      end
    end
  end


end
