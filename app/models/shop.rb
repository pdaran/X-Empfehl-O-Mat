# frozen_string_literal: true

class Shop < ApplicationRecord
  has_many :categories, dependent: :destroy
  validates :name, presence: true, length: { minimum: 3 }
  validates :email, presence: true, length: { minimum: 7 }
  validates :address, presence: true, length: { minimum: 7 }
  validates :phone_no, presence: true, length: { minimum: 7 }
  enum status: { active: 'active', blocked: 'blocked' }

  has_one_attached :image do |attachable|
    attachable.variant :large, resize_to_fill: [250, 250]
    attachable.variant :thumbnail, resize_to_fill: [56, 56]
    attachable.variant :medium, resize_to_limit: [100, 100]
  end
end
