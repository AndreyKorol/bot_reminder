module EventsCommand
  def events!(*args)
    events = if 'all'.in? args
               User.includes(:events).find_by(chat_id: chat['id']).events
             else
               User.includes(:events).where(chat_id: chat['id']).with_active_events.first.events
             end
    text = events.map do |event|
      "#{event.name} - #{event.date.in_time_zone('Minsk').strftime('%a, %d %b %Y %R')} - #{event.description}"
    end.join("\n")
    respond_with :message, text: text
  end
end
