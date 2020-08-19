class ApplicationMailer < ActionMailer::Base
  default from: ENV["HOST_NAME"]
  layout "mailer"
end
