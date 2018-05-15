# frozen_string_literal: true

class CreateBids < ActiveRecord::Migration[5.2]
  def change
    create_table :bids do |t|
      t.belongs_to :user
      t.belongs_to :lot
      t.timestamp :created_at, null: false
      t.float :proposed_price, null: false
    end
  end
end
