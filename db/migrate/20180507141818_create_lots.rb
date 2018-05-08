class CreateLots < ActiveRecord::Migration[5.2]
  def change
    create_table :lots do |t|
      t.belongs_to :user, index: true
      t.text :title, null: false
      t.string :image
      t.text :description
      t.integer :status, null: false, default: 0
      t.timestamp :created_at, null: false
      t.float :current_price, null: false
      t.float :estimated_price, null: false
      t.timestamp :lot_start_time, null: false
      t.timestamp :lot_end_time, null: false
    end
  end
end
