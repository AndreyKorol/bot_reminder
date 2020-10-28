class AddChatIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :chat_id, :bigint, null: false
  end
end
