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
      expect(user.chat_id).to be_present
    end
  end

  describe '#event!' do
    subject { -> { dispatch_command :event } }

    it do
      should respond_with_message 'Type name for event.'

      expect { dispatch_message('Event') }.to make_telegram_request(bot, :sendMessage)
        .with(hash_including(text: 'Type date and time in format: dd.mm hh:mm. For example 09.11 13:15'))

      expect { dispatch_message('09.11 13:15') }.to make_telegram_request(bot, :sendMessage)
        .with(hash_including(text: 'Type the description of event.'))

      expect { dispatch_message('My first event') }.to make_telegram_request(bot, :sendMessage)
        .with(hash_including(text: 'Thanks, we will notify you one hour before the start'))

      event = Event.first
      expect(event.name).to eq('Event')
      expect(event.date).to eq(DateTime.new('09-11 13:15'))
      expect(event.description).to eq('My first event')
    end
  end

  describe '#events!' do
    subject { -> { dispatch_command :events } }
    before do
      user = create(:user)
      create(:event, user: user, name: 'Past Event', date: DateTime.now - 1.hour)
      create(:event, user: user, name: 'First Event')
      create(:event, user: user, name: 'Second Event')
    end

    it '/events' do
      events = [
        "First Event - 28.10 00:00 - default description",
        "Second Event - 28.10 00:00 - default description"
      ]
      should respond_with_message events.join("\n")
    end

    it '/events all' do
      events = [
        "Past Event - 27.10 23:00 - default description",
        "First Event - 28.10 00:00 - default description",
        "Second Event - 28.10 00:00 - default description"
      ]
      should respond_with_message events.join("\n")
    end
  end
end
