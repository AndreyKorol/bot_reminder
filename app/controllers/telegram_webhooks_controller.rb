class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  self.session_store = :file_store, { expires_in: 1.month }

  def start!(*)
    respond_with :message, text: t('start')
  end
end
