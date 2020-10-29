module EventCommand
  def event!(*)
    if registered?
      save_context :event_name
      respond_with :message, text: t('event.name')
    else
      respond_with :message, text: t('event.register_first')
    end
  end

  def event_name(*)
    save_context :event_datetime
    session[:name] = update.dig('message', 'text')
    respond_with :message, text: t('event.datetime')
  end

  def event_datetime(*date_and_time)
    save_context :event_description
    session[:datetime] = DateTime.parse("#{date_and_time.join(' ')}+3:00") - 11.seconds
    respond_with :message, text: t('event.description')
  end

  def event_description(*)
    Event.create(name: session[:name],
                 date: session[:datetime],
                 description: update.dig('message', 'text'),
                 user: User.find_by(chat_id: chat['id']))
    respond_with :message, text: t('event.complete')
  end
end
