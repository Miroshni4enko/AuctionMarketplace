class AddWinnerColumnToLots < ActiveRecord::Migration[5.2]
  def change
    add_column :lots, :winner, :integer
  end
end
