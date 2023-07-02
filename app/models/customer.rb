# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :recommendations, dependent: :destroy
end
