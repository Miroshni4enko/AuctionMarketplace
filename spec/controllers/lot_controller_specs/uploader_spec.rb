# frozen_string_literal: true

require "rails_helper"

RSpec.describe LotsController, type: :controller do
  describe "Put #update image" do
    include_examples "success response"

    let(:image) { "lot_ex.jpg" }
    let(:path_to_image) { Rails.root.join("spec", "fixtures", "files", image) }

    before do
      login
      @new_lot = FactoryBot.create(:lot, user: @user)
      # alternative way ti upload file from fixture fixture_file_upload( "./spec/fixtures/files/lot_ex.jpg", "image/jpeg") }
      put :update,
          params: { id: @new_lot.id,
                    image: Rack::Test::UploadedFile.new(path_to_image, "image/jpeg") }
      @new_lot.reload
    end

    it "should uploads image file" do
      expect(@new_lot.image.file).to be
    end

    it "should eq file name" do
      expect(@new_lot.image_identifier).to eq image
    end
  end
end
