require 'carrierwave/test/matchers'
require "rails_helper"

describe LotImageUploader do
  include CarrierWave::Test::Matchers

  let(:lot) { FactoryBot.create(:random_lot) }
  let(:uploader) { LotImageUploader.new(lot, :image) }

  before do
    LotImageUploader.enable_processing = true
    File.open('./spec/fixtures/files/lot_ex.jpg') { |f| uploader.store!(f) }
  end

  after do
    LotImageUploader.enable_processing = false
    uploader.remove!
  end

  its(:extension_whitelist) { is_expected.to eq( %w(jpg jpeg gif png)) }

=begin
  context 'the thumb version' do
    it "scales down a landscape image to be exactly 350 by 350 pixels" do
      expect(uploader.thumb).to have_dimensions(350, 350)
    end
  end

  context 'the small version' do
    it "scales down a landscape image to fit within 50 by 50 pixels" do
      expect(uploader.small_thumb).to be_no_larger_than(50, 50)
    end
  end
  it "makes the image readable only to the owner and not executable" do
    expect(uploader).to have_permissions(0600)
  end

=end
end