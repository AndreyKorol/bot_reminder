class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  include Telegram::Bot::UpdatesController::Session
  self.session_store = :file_store, { expires_in: 1.month }

  include StartCommand
  include EventCommand
  include EventsCommand

  def registered?
    User.where(chat_id: chat['id']).exists?
  end

  def session_key
    chat['id']
  end
end
