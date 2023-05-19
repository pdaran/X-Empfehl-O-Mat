# frozen_string_literal: true

class Product < ApplicationRecord
  include Visible

  belongs_to :category

  has_one_attached :image do |attachable|
    attachable.variant :thumbnail, resize_to_limit: [250, 250]
  end

  validates :product, presence: true, length: { minimum: 3 }

  validates :desc, presence: true, length: { minimum: 15 }
end
