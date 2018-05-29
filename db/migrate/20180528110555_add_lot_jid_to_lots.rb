class AddLotJidToLots < ActiveRecord::Migration[5.2]
  def change
    add_column :lots, :lot_jid_in_process, :string
    add_column :lots, :lot_jid_closed, :string
  end
end
