class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("EMAIL_FROM", "from@example.com"), reply_to: ENV.fetch("EMAIL_REPLY_TO", "from@example.com")
  layout "mailer"
end
