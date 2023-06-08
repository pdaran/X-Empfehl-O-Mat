# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :attrs, dependent: :destroy

  belongs_to :shop
  validates :title, presence: true, length: { minimum: 3 }

  enum status: { active: 'active', deactivated: 'deactivated' }

  has_one_attached :image do |attachable|
    attachable.variant :large, resize_to_fill: [250, 250]
    attachable.variant :thumbnail, resize_to_fill: [56, 56]
    attachable.variant :medium, resize_to_limit: [100, 100]
  end
end
