# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotsController, type: :controller do

  describe "Put #update" do
    include_examples "check on auth", "put", :update, params: { id: 1 }

    describe "result after sign in" do
      describe "update current user lots" do
        include_examples "success response"

        before do
          login
          @new_lot = FactoryBot.create(:lot, user: @user)
          @new_price = @new_lot.estimated_price + 2.00
          put :update,
              params: { id: @new_lot.id,
                       estimated_price: @new_price }
          @new_lot.reload
        end

        it "change status" do
          expect(@new_lot.estimated_price).to eq(@new_price)
        end
      end

      describe "update current user lots in 'in progress' status" do
        include_examples "unprocessable entity"

        before do
          login
          @new_lot = FactoryBot.create(:lot, :with_in_process_status, user: @user)

          put :update,
              params: { id: @new_lot.id,
                       status: :pending }
          @new_lot.reload
        end
      end
    end

    describe " update another user lots" do
      include_examples "unprocessable entity"

      before do
        login
        another_user = FactoryBot.create(:user)
        @new_lot = FactoryBot.create(:lot, user: another_user)
        put :update,
            params: { id: @new_lot.id,
                     status: :in_process }
        @new_lot.reload
      end
    end
  end
end
