# frozen_string_literal: true

class Attr < ApplicationRecord
  has_many :product_attrs, dependent: :destroy
  has_many :products, through: :product_attr
  belongs_to :category

  enum attrtype: { bool: 'bool', numeric: 'numeric', text: 'text' }
  enum status: { active: 'active', deactivated: 'deactivated' }

  validates :name, presence: true, length: { minimum: 3 }
  validates :unit, presence: true, if: :numeric?
  validates :unit, absence: true, unless: :numeric?

  def numeric?
    attrtype == 'numeric'
  end
end
