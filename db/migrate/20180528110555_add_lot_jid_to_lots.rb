class AddLotJidToLots < ActiveRecord::Migration[5.2]
  def change
    add_column :lots, :lot_jid, :integer
  end
end
