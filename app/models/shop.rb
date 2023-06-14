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

  def generate_password_reset_token
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.now
    save(validate: false)
  end
end
