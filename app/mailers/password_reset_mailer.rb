# frozen_string_literal: true

class PasswordResetMailer < ApplicationMailer
  layout 'mailer'
  def forgot_password(shop)
    @shop = shop
    @greeting = 'Hello '
    mail(
      to: shop.email,
      subject: 'Reset password instructions'
    )
  end
end
