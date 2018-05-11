class CreateBids < ActiveRecord::Migration[5.2]
  def change
    create_table :bids do |t|
      t.belongs_to :user, index: true
      t.belongs_to :lot, index: true
      t.timestamp :created_at, null: false
      t.float :proposed_price, null: false
    end
  end
end
