module EventsCommand
  def events!(*args)
    if registered?
      events = if 'all'.in? args
                 User.includes(:events).find_by(chat_id: chat['id']).events
               else
                 User.includes(:events).where(chat_id: chat['id']).with_active_events.first&.events || []
               end
      text = events.map { |event| event.to_s }.join("\n")
      respond_with :message, text: text.present? ? text : t('events.no_active_events')
    else
      respond_with :message, text: t('event.register_first')
    end
  end
end
