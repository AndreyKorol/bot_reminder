class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext
  include Telegram::Bot::UpdatesController::Session
  self.session_store = :file_store, { expires_in: 1.month }

  def start!(*)
    save_context :name
    respond_with :message, text: t('start')
  end

  def message(name)
    binding.pry
  end

  def name(name)
    save_context :email
    session[:name] = name
    respond_with :message, text: t('email')
  end

  def email(email)
    User.create(name: session[:name], email: email)
    respond_with :message, text: t('registration_completed')
  end

  def session_key
    chat['id']
  end
end
