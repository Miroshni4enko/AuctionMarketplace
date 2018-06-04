# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotsController, type: :controller do
  describe "Put #update image" do
    include_examples "success response"

    let(:image) { "lot_ex.jpg" }

    before do
      current_user = FactoryBot.create(:user)
      @new_lot = FactoryBot.create(:lot, user: current_user)
      request.headers.merge! current_user.create_new_auth_token
      # alternative way ti upload file from fixture fixture_file_upload( "./spec/fixtures/files/lot_ex.jpg", "image/jpeg") }
      put :update,
          params: { id: @new_lot.id,
                    image: Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "files", image), "image/jpeg") }
    end


    it "uploads image" do
      @new_lot.reload
      expect(@new_lot.image.file).to be
    end
  end
end
