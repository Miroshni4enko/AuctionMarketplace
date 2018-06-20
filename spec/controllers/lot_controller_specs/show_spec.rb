# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotsController, type: :controller do

  describe "Get #show " do
    describe "result without sign in" do

      it "doesn't give you anything if you don't log in" do
        get :show, params: { id: 11 }
        expect(response).to have_http_status(401)
      end
    end

    describe "result after sign in" do

      login_user_for_each_test

      context "success" do
        include_examples "success response"

        before do
          @new_lot = FactoryBot.create(:lot, :with_in_process_status, user: @logged_user)
          get :show, params: { id: @new_lot.id }
        end

        it "should have responce with equal params " do
          @serializer = LotWithAssociationSerializer.new(@new_lot)
          @serialization = ActiveModelSerializers::Adapter.create(@serializer)
          expect(JSON.parse(@serialization.to_json)).to eq(json_response_body)
        end
      end

      context "fail " do
        include_examples "not found"

        before  do
          get :show, params: { id: -17 }
        end
      end
    end
  end

end
