require 'rails_helper'
require 'telegram/bot/updates_controller/rspec_helpers'

RSpec.describe TelegramWebhooksController, type: :telegram_bot_controller do
  describe '#start!' do
    subject { -> { dispatch_command :start } }

    it do
      should respond_with_message "Hi, what's your name?"

      expect { dispatch_message('Andrey') }.to make_telegram_request(bot, :sendMessage)
        .with(hash_including(text: "To complete your register we need your email."))

      expect { dispatch_message('email@example.com') }.to make_telegram_request(bot, :sendMessage)
        .with(hash_including(text: "Thanks, now you are able to add events. To add event type /event and follow instruction. To list your active events type /events, if you want to list all events including past type /events all."))

      user = User.first
      expect(user.email).to eq('email@example.com')
      expect(user.name).to eq('Andrey')
    end
  end
  describe '#event!' do
    subject { -> { dispatch_command :event } }
  end
  describe '#events!' do
    subject { -> { dispatch_command :events } }
  end
end
