# frozen_string_literal: true

class Shop < ApplicationRecord
  has_secure_password
  has_many :categories, dependent: :destroy
  validates :name, presence: true, length: { minimum: 3 }
  validates :email, presence: true, uniqueness: true,
                    format: { with: /\A[^@\s]+@[^@\s]+\z/, message: I18n.t('form_labels.invalid_email') }
  validates :address, presence: true, length: { minimum: 7 }
  validates :phone_no, presence: true, length: { minimum: 7 }, uniqueness: true
  enum status: { active: 'active', blocked: 'blocked' }

  has_one_attached :image do |attachable|
    attachable.variant :large, resize_to_fill: [250, 250]
    attachable.variant :thumbnail, resize_to_fill: [56, 56]
    attachable.variant :medium, resize_to_limit: [100, 100]
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    PasswordResetMailer.forgot_password(self).deliver # Sends an e-mail with the reset link for the the password
  end

  # This generates a random password reset token for the shop
  def generate_token(column)
    loop do
      self[column] = SecureRandom.urlsafe_base64
      break unless Shop.exists?(column => self[column])
    end
  end
end
