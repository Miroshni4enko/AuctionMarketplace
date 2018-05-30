# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotsController, type: :controller do
  describe "GET #index" do
    describe "result without sign in" do
      it "doesn't give you anything if you don't log in" do
        get :index
        expect(response).to have_http_status(401)
      end
    end
    describe "result after sign in" do
      include_examples "lots_pagination"
      include_examples "success response"
      before do
        current_user = FactoryBot.create(:user)
        request.headers.merge! current_user.create_new_auth_token
        get :my, params: { filter: :all }
      end
    end
  end

  describe "Post #create " do
    describe "result without sign in" do
      it "doesn't give you anything if you don't log in" do
        post :create
        expect(response).to have_http_status(401)
      end
    end


    describe "result after sign in" do
      include_examples "success response"
      before do
        @current_user = FactoryBot.create(:user)
        new_lot_params = FactoryBot.attributes_for(:lot)
        request.headers.merge! @current_user.create_new_auth_token
        post :create, params: new_lot_params
      end

      it "adds should add lot" do
        expect(@current_user.lots.count).to eq(1)
      end
      it "should add two jobs" do
        expect(LotStatusUpdateWorker.jobs.size).to eq(2)
      end

    end

    describe "Put #update" do
      describe "result without sign in" do
        it "doesn't give you anything if you don't log in" do
          put :update, params: { id: 1 }
          expect(response).to have_http_status(401)
        end
      end

      describe "result after sign in" do
        describe "update current user lots" do
          include_examples "success response"
          before do
            current_user = FactoryBot.create(:user)
            @new_lot = FactoryBot.create(:lot, user: current_user)
            request.headers.merge! current_user.create_new_auth_token
            put :update,
                params: { id: @new_lot.id,
                         status: :in_process }
            @new_lot.reload
          end

          it "change status" do
            expect(@new_lot.status).to eq("in_process")
          end
        end

        describe "update current user lots in 'in progress' status" do
          include_examples "unprocessable entity"
          before do
            current_user = FactoryBot.create(:user)
            @new_lot = FactoryBot.create(:lot, :with_in_process_status, user: current_user)
            request.headers.merge! current_user.create_new_auth_token
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
          current_user = FactoryBot.create(:user)
          another_user = FactoryBot.create(:user)
          @new_lot = FactoryBot.create(:lot, user: another_user)
          request.headers.merge! current_user.create_new_auth_token
          put :update,
              params: { id: @new_lot.id,
                       status: :in_process }
          @new_lot.reload
        end

      end
    end
  end

  describe "Post #delete " do
    describe "result without sign in" do
      it "doesn't give you anything if you don't log in" do
        delete :destroy, params: { id: 11 }
        expect(response).to have_http_status(401)
      end
    end


    describe "result after sign in" do
      include_examples "success response"
      before do
        @current_user = FactoryBot.create(:user)
        @new_lot = FactoryBot.create(:lot, user: @current_user)
      end

      it "should add two jobs" do
        expect(LotStatusUpdateWorker.jobs.size).to eq(2)
      end
      it "adds should delete and two jobs lot" do
        request.headers.merge! @current_user.create_new_auth_token
        delete :destroy, params: { id: @new_lot.id }
        expect(@current_user.lots.count).to eq(0)
        expect(LotStatusUpdateWorker.jobs.size).to eq(2)
      end
    end
  end

  describe "Get #show " do
    describe "result without sign in" do
      it "doesn't give you anything if you don't log in" do
        get :show, params: { id: 11 }
        expect(response).to have_http_status(401)
      end
    end


    describe "result after sign in" do
      include_examples "success response"
      before do
        @current_user = FactoryBot.create(:user)
        @new_lot = FactoryBot.create(:lot, user: @current_user)
        FactoryBot.create(:bid, lot: @new_lot, user: @current_user)
        request.headers.merge! @current_user.create_new_auth_token
        get :show, params: { id: @new_lot.id }
      end

      it "should have responce with equal params " do

        # Create a serializer instance
        @serializer = LotWithAssociationSerializer.new(@new_lot)
        # TODO create test for JSON format
        # Create a serialization based on the configured adapter
        @serialization = ActiveModelSerializers::Adapter.create(@serializer)
        expect(JSON.parse(@serialization.to_json)).to eq(json_response_body)
      end
    end
  end


  def json_response_body
    JSON.parse(response.body)
  end

end
