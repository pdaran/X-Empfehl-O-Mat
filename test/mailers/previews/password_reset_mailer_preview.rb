# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/password_reset_mailer
class PasswordResetMailerPreview < ActionMailer::Preview
  def password_reset_email
    shop = Shop.first
    shop.password_reset_token = SecureRandom.urlsafe_base64
    PasswordResetMailer.password_reset_email(shop)
  end

  def user_password_reset_email
    user = User.first
    user.password_reset_token = SecureRandom.urlsafe_base64
    PasswordResetMailer.password_reset_email(user)
  end
end
