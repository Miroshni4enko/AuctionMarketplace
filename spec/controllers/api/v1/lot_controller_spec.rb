# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::LotsController, type: :controller do
  describe "GET #index " do
    describe "result without sign in" do
      it "doesn't give you anything if you don't log in" do
        get :index
        expect(response).to have_http_status(401)
      end
    end

    describe "result after sign in" do

      before do
        current_user = FactoryBot.create(:random_user)
        request.headers.merge! current_user.create_new_auth_token
        get :index
      end

      it "get success result after sign_in" do
        expect(response).to be_successful
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

  describe "GET #my" do

    describe "result without sign in" do
      it "doesn't give you anything if you don't log in" do
        get :my
        expect(response).to have_http_status(401)
      end
    end

    describe "result after sign in" do
      before do
        @current_user = FactoryBot.create(:random_user)
        another_user = FactoryBot.create(:random_user)
        10.times do
          FactoryBot.create(:random_lot, user: @current_user)
          FactoryBot.create(:random_lot, user: another_user)
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
        @current_user = FactoryBot.create(:random_user)
        new_lot_params = FactoryBot.attributes_for(:random_lot)
        request.headers.merge! @current_user.create_new_auth_token
        post :create, params: new_lot_params
      end

      it "get success result after sign_in" do
        expect(response).to be_successful
      end

      it "get success result after sign_in" do
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
        before do
          current_user = FactoryBot.create(:random_user)
          @new_lot = FactoryBot.create(:random_lot, user: current_user)
          request.headers.merge! current_user.create_new_auth_token
          put :update,
              params: { id: @new_lot.id,
                       status: :in_process }
          @new_lot.reload
        end

        it "gets success result after sign_in" do
          expect(response).to be_successful
          Rails.logger.debug response.body
        end
        it "change status" do
          expect(@new_lot.status).to eq("in_process")
        end
# TODO write test for upload file
=begin
image: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'files', 'lot_ex.jpg'), 'image/jpeg')
        it "uploads file" do
          expect(@new_lot.image).to be
        end
=end
      end
    end
  end

  def json_response_body
    JSON.parse(response.body)
  end
end
