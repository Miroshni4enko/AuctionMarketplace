class ChangePriceScale < ActiveRecord::Migration[5.2]
  def change
    change_table :lots do |t|
      t.change :current_price, :float, null: false, scale: 2
      t.change :estimated_price, :float, null: false, scale: 2
    end

    change_table :bids do |t|
      t.change :proposed_price, :float, null: false, scale: 2
    end
  end
end
