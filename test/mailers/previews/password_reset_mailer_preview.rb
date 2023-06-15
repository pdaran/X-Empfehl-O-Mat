# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/password_reset_mailer
class PasswordResetMailerPreview < ActionMailer::Preview
  def forgot_password
    shop = Shop.find_by_email('admin@local.de')
    PasswordResetMailer.forgot_password(shop)
  end
end
