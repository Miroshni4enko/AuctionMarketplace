class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.belongs_to :bid, index: true
      t.text :arrival_location, null: false
      t.string :arrival_type, null: false
      t.string :status, null: false

      t.timestamps
    end
  end
end
