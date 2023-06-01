# frozen_string_literal: true

class Attr < ApplicationRecord
  has_many :products, through: :product_attr
  belongs_to :category

  enum attrtype: { bool: 'bool', numeric: 'numeric', text: 'text' }
end
