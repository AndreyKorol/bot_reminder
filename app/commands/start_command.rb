module StartCommand
  def start!(*)
    if registered?
      respond_with :message, text: t('user.already_registered')
    else
      save_context :name
      respond_with :message, text: t('user.start')
    end
  end

  def name(name)
    save_context :email
    session[:name] = name
    respond_with :message, text: t('user.email')
  end

  def email(email)
    if URI::MailTo::EMAIL_REGEXP.match? email
      save_context :code
      code = rand(10**6).to_s
      session[:code] = code
      session[:email] = email
      ApproveEmailMailer.send_mail(email, code).deliver_now
      respond_with :message, text: t('user.approve_email')
    else
      save_context :email
      respond_with :message, text: t('user.incorrect_email')
    end
  end

  def code(code)
    attributes = [:name, :email, :chat_id].zip([session[:name], session[:email], chat['id']]).to_h
    if code == session[:code]
      session[:code] = nil
      User.where(email: session[:email]).first_or_create(attributes).update(attributes)
      respond_with :message, text: t('user.registration_completed')
    else
      save_context :code
      respond_with :message, text: t('user.wrong_code')
    end
  end
end
