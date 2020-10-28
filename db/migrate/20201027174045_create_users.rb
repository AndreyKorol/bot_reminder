class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false

      t.timestamps
    end
    add_index :users, :email
  end
end
