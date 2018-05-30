class AddWinningBidToLots < ActiveRecord::Migration[5.2]
  def change
    add_column :lots, :winning_bid, :integer
  end
end
