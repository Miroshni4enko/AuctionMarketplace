class CreateLots < ActiveRecord::Migration[5.2]
  def change
    create_table :lots do |t|
      t.belongs_to :user, index: true
      t.text :title, null: false
      t.string :image
      t.text :description
      t.string :status, null: false
      t.datetime :created_at, null: false
      t.integer :current_price, null: false
      t.integer :estimated_price, null: false
      t.datetime :lot_start_time, null: false
      t.datetime :lot_end_time, null: false

      t.timestamps
    end
  end
end
