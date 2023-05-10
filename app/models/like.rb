# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :customer
  belongs_to :product
end
