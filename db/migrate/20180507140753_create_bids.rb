class CreateBids < ActiveRecord::Migration[5.2]
  def change
    create_table :bids do |t|
      t.datetime :bid_creation_time
      t.integer :proposed_price
      t.integer :lot_id
      t.integer :user_id

      t.timestamps
    end
  end
end
