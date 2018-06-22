# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotsController, type: :controller do

  describe "Post #delete " do
    describe "result without sign in" do

      it "doesn't give you anything if you don't log in" do
        delete :destroy, params: { id: 11 }
        expect(response).to have_http_status(401)
      end
    end

    describe "result after sign in" do

      login_user_for_each_test

      context "success" do
        it "should delete lot and two jobs" do
          Sidekiq::Testing.inline! do
            ss = Sidekiq::ScheduledSet.new
            ss.clear
            @new_lot = create(:lot, user: @user)
            delete :destroy, params: { id: @new_lot.id }
            expect(ss.size).to eq(0)
            expect(@user.lots.count).to eq(0)
          end
        end
      end

      context "fail " do
        include_examples "not found"
        before  do
          delete :destroy, params: { id: -1 }
        end
      end
    end
  end
end
