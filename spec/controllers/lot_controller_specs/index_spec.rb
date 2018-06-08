# frozen_string_literal: true

require "rails_helper"

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

end
