class CreateBids < ActiveRecord::Migration[5.2]
  def change
    create_table :bids do |t|
      t.belongs_to :user, index: true
      t.belongs_to :lot, index: true
      t.datetime :bid_creation_time, null: false
      t.integer :proposed_price, null: false

      t.timestamps
    end
  end
end
