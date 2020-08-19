class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("user.activation.activation")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("forgot.reset.title")
  end
end
