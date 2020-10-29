require 'i18n'

class EventNotificationJob < ActiveJob::Base
  queue_as :notifications

  def perform(event_id, chat_id)
    event = Event.find_by(id: event_id).to_s
    Telegram.bot.send_message(chat_id: chat_id, text: I18n.t('event_string', event: event))
  end
end
