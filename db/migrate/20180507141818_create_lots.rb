class CreateLots < ActiveRecord::Migration[5.2]
  def change
    create_table :lots do |t|
      t.text :title
      t.string :image
      t.text :description
      t.string :status
      t.datetime :created_at
      t.integer :current_price
      t.integer :estimated_price
      t.datetime :lot_start_time
      t.datetime :lot_end_time

      t.timestamps
    end
  end
end
