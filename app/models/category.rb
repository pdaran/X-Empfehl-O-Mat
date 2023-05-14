# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3 }
  
  has_one_attached :image do |attachable|
    attachable.variant :thumbnail, resize_to_limit: [250, 250]
  end
end


