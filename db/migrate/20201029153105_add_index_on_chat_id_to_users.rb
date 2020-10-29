class AddIndexOnChatIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :chat_id, unique: true
  end
end
