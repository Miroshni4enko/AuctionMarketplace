class DeleteRerememberable < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :remember_created_at
  end
end
