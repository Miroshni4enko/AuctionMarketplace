class ChangeOrderReference < ActiveRecord::Migration[5.2]
  def change
    remove_belongs_to :orders, :bid
    add_belongs_to :orders, :lot
  end
end
