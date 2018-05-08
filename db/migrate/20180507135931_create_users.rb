class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :phone, null: false, unique: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :date, null: false
    end
  end
end
