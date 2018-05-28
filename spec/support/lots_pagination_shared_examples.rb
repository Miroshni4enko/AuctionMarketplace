# frozen_string_literal: true

RSpec.shared_examples "lots_pagination" do

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
