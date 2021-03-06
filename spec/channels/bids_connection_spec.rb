# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationCable::Connection, type: :channel do

  it "successfully connects" do
    @user = create(:user)
    connect "/cable", headers: @user.create_new_auth_token
    expect(connection.current_user).to eq(@user)
  end

  it "rejects connection" do
    expect { connect "/cable" }.to have_rejected_connection
  end

end
