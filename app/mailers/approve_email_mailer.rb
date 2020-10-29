class ApproveEmailMailer < ActionMailer::Base
  default from: 'from@example.com'

  def send_mail(to, code)
    @code = code
    mail(to: to, subject: 'Approve your email on Reminder')
  end
end
