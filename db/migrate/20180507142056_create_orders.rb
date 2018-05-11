class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.belongs_to :bid, index: true
      t.text :arrival_location, null: false
      t.integer :arrival_type, null: false, default: 0
      t.integer :status, null: false, default: 0
    end
  end
end
