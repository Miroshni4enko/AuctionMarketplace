# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotsController, type: :controller do
  describe "GET #my" do
    describe "result without sign in" do
      it "doesn't give you anything if you don't log in" do
        get :my
        expect(response).to have_http_status(401)
      end
    end
    describe "result after sign in" do
      before do
        @current_user = FactoryBot.create(:user)
        another_user = FactoryBot.create(:user)
        10.times do
          FactoryBot.create(:lot, user: @current_user)
          FactoryBot.create(:lot, user: another_user)
        end
        request.headers.merge! @current_user.create_new_auth_token

        get :my

        @response_lot_ids = json_response_body["lots"].map { |lot_hash| lot_hash["id"] }
      end

      it "get success result after sign_in" do
        expect(response).to be_successful
      end

      it "gets only current user lots" do
        @current_user.reload
        expect(@current_user.lots.map(&:id)).to match_array(@response_lot_ids)
      end

      it "has only 10 lots" do
        expect(@response_lot_ids.size).to eq(10)
      end


      it "get Per-Page header = 10" do
        expect(json_response_body["meta"]["pagination"]["per_page"]).to eq(10)
      end

      it "get total_pages header" do
        expect(json_response_body["meta"]["pagination"]["total_pages"]).to be
      end

      it "get total_lots header" do
        expect(json_response_body["meta"]["pagination"]["total_lots"]).to be
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
      before do
        @current_user = FactoryBot.create(:user)
        new_lot_params = FactoryBot.attributes_for(:lot)
        request.headers.merge! @current_user.create_new_auth_token
        post :create, params: new_lot_params
      end

      it "get success result after sign_in" do
        expect(response).to be_successful
      end

      it "adds should add lot" do
        expect(@current_user.lots.count).to eq(1)
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
          before do
            current_user = FactoryBot.create(:user)
            @new_lot = FactoryBot.create(:lot, user: current_user)
            request.headers.merge! current_user.create_new_auth_token
            put :update,
                params: { id: @new_lot.id,
                         status: :in_process }
            @new_lot.reload
          end

          it "gets success result after sign_in" do
            expect(response).to be_successful
          end
          it "change status" do
            expect(@new_lot.status).to eq("in_process")
          end
        end

        describe "update current user lots in 'in progress' status"  do
          before do
            current_user = FactoryBot.create(:user)
            @new_lot = FactoryBot.create(:lot, :with_in_process_status, user: current_user)
            request.headers.merge! current_user.create_new_auth_token
            put :update,
                params: { id: @new_lot.id,
                         status: :pending }
            @new_lot.reload
          end
          it " can't change lot in 'in progress' status" do
            expect(response).to be_unprocessable
          end
        end
      end

      describe " update another user lots" do
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

        it " can't change anther user lot" do
          expect(response).to be_unprocessable
        end
      end
    end
  end

  def json_response_body
    JSON.parse(response.body)
  end
end
