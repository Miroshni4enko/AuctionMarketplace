# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotsController, type: :controller do
  describe "Put #update image" do
    let(:image) { "lot_ex.jpg" }

    before do
      current_user = FactoryBot.create(:user)
      @new_lot = FactoryBot.create(:random_lot, user: current_user)
      request.headers.merge! current_user.create_new_auth_token
      put :update,
          params: { id: @new_lot.id,
                   image: Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "files", image), "image/jpeg") }
    end

    it "gets success result after sign_in" do
      expect(response).to be_successful
    end

    it "uploads image" do
      expect(@new_lot.image).to be
    end
  end
end
