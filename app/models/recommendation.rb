# frozen_string_literal: true

class Recommendation < ApplicationRecord
  belongs_to :customer
  belongs_to :product
end
