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
        .with(hash_including(text: "Paste code that we sent to email"))

      expect { dispatch_message(controller.send(:session)[:code]) }.to make_telegram_request(bot, :sendMessage)
        .with(hash_including(text: "Thanks, now you are able to add events. To add event type /event and follow instructions. To list your active events type /events, if you want to list all events including past type /events all."))

      user = User.first
      expect(user.email).to eq('email@example.com')
      expect(user.name).to eq('Andrey')
      expect(user.chat_id).to be_present
    end
  end

  describe '#event!' do
    subject { -> { dispatch_command :event } }
    before { create(:user) }

    it do
      should respond_with_message 'Type name for event.'

      expect { dispatch_message('Event') }.to make_telegram_request(bot, :sendMessage)
        .with(hash_including(text: 'Type date and time in format: day.month hours:minutes. For example 29.10 13:15 (Thu, 29 Oct 2020 13:15)'))

      expect { dispatch_message("29.10 13:15") }.to make_telegram_request(bot, :sendMessage)
        .with(hash_including(text: 'Type the description of event.'))

      expect { dispatch_message('My first event') }.to make_telegram_request(bot, :sendMessage)
        .with(hash_including(text: 'Thanks, we will notify you one hour before the start'))

      event = Event.first
      expect(event.name).to eq('Event')
      expect(event.date.in_time_zone('Minsk').strftime('%a, %d %b %Y %R')).to eq('Thu, 29 Oct 2020 13:15')
      expect(event.description).to eq('My first event')
    end
  end

  describe '#events!' do
    before do
      user = create(:user)
      create(:event, user: user, name: 'Past Event', date: DateTime.new(2020, 9, 10, 13, 15, 0, '+3'))
      create(:event, user: user, name: 'First Event', date: DateTime.new(2020, 11, 10, 13, 15, 0, '+3'))
      create(:event, user: user, name: 'Second Event', date: DateTime.new(2020, 12, 10, 13, 15, 0, '+3'))
    end

    context '/events' do
      subject { -> { dispatch_command :events } }

      it do
        text = [
          "First Event - Tue, 10 Nov 2020 13:15 - default description",
          "Second Event - Thu, 10 Dec 2020 13:15 - default description"
        ].join("\n")
        should respond_with_message text
      end
    end

    context '/events all' do
      subject { -> { dispatch_command :events, 'all' } }

      it do
        text = [
          "Past Event - Thu, 10 Sep 2020 13:15 - default description",
          "First Event - Tue, 10 Nov 2020 13:15 - default description",
          "Second Event - Thu, 10 Dec 2020 13:15 - default description"
        ].join("\n")
        should respond_with_message text
      end
    end
  end
end
