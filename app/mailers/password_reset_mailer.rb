# frozen_string_literal: true

class PasswordResetMailer < ApplicationMailer
  def password_reset_email(user_or_shop)
    @user_or_shop = user_or_shop
    @reset_password_url = edit_reset_password_url(token: @user_or_shop.password_reset_token, locale: I18n.locale)
    mail(to: @user_or_shop.email, subject: 'Reset Your Password')
  end
end
