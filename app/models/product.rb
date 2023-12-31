# frozen_string_literal: true

class Product < ApplicationRecord
  include Visible

  belongs_to :category
  has_many :product_attrs, dependent: :destroy
  has_many :attrs, through: :product_attrs
  has_many :likes, dependent: :destroy
  has_many :recommendations, dependent: :destroy

  has_one_attached :image do |attachable|
    attachable.variant :large, resize_to_fill: [250, 250]
    attachable.variant :thumbnail, resize_to_fill: [56, 56]
    attachable.variant :medium, resize_to_limit: [100, 100]
  end

  validates :product, presence: true, length: { minimum: 3 }

  validates :desc, presence: true, length: { minimum: 15, maximum: 123 }
end
