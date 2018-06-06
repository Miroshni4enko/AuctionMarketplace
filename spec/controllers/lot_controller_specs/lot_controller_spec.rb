# frozen_string_literal: true

require "rails_helper"
require "sidekiq/testing"

RSpec.describe LotsController, type: :controller do
  describe "GET #index" do
    include_examples "check on auth", "get", :index

    describe "result after sign in" do
      include_examples "lots_pagination"
      include_examples "success response"
      before do
        login
        get :index
      end
    end
  end

  describe "Post #create " do
    include_examples "check on auth", "post", :create

    describe "result after sign in" do
      include_examples "success response"
      before do
        login
        new_lot_params = FactoryBot.attributes_for(:lot, user: @user)
        post :create, params: new_lot_params
      end

      it "should add lot" do
        expect(@user.lots.count).to eq(1)
      end
      it "should add two jobs" do
        expect(LotStatusUpdateWorker.jobs.size).to eq(2)
      end

    end

    describe "Put #update" do
      include_examples "check on auth", "put", :update, params: { id: 1 }

      describe "result after sign in" do
        describe "update current user lots" do
          include_examples "success response"
          before do
            login
            @new_lot = FactoryBot.create(:lot, user: @user)
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

  describe "Post #delete " do
    describe "result without sign in" do
      it "doesn't give you anything if you don't log in" do
        delete :destroy, params: { id: 11 }
        expect(response).to have_http_status(401)
      end
    end


    describe "result after sign in" do
      it "should delete lot and two jobs" do
        Sidekiq::Testing.inline! do
          ss = Sidekiq::ScheduledSet.new
          ss.clear
          login
          @new_lot = FactoryBot.create(:lot, user: @user)
          delete :destroy, params: { id: @new_lot.id }
          expect(ss.size).to eq(0)
          expect(@user.lots.count).to eq(0)
        end
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
        login
        @new_lot = FactoryBot.create(:lot, :with_in_process_status, user: @user)
        get :show, params: { id: @new_lot.id }
      end

      it "should have responce with equal params " do
        @serializer = LotWithAssociationSerializer.new(@new_lot)
        @serialization = ActiveModelSerializers::Adapter.create(@serializer)
        expect(JSON.parse(@serialization.to_json)).to eq(json_response_body)
      end
    end
  end

end
