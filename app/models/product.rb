# frozen_string_literal: true



class Product < ApplicationRecord

  include Visible

  belongs_to :category



  validates :product, presence: true, length: { minimum: 3 }

  validates :desc, presence: true, length: { minimum: 15 }

end

