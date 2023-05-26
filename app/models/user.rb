# frozen_string_literal: true

# email:string
# password_digest:string
#
# password:string virtual
# password_confirmation:string virtual
# admin: bool
# shop: bool

class User < ApplicationRecord
  has_secure_password

  # Verify that email field is not blank and that it doesn't already exist in the db (prevents duplicates):
  validates :email, presence: true, uniqueness: true,
                    format: { with: /\A[^@\s]+@[^@\s]+\z/, message: I18n.t('form_labels.invalid_email') }

  def shop?
    self[:shop] || self[:admin]
  end
end
