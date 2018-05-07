class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.text :arrival_location
      t.string :arrival_type
      t.string :status
      t.integer :bid_id

      t.timestamps
    end
  end
end
