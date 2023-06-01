# frozen_string_literal: true

class ProductAttr < ApplicationRecord
  belongs_to :product
  belongs_to :attr
end
