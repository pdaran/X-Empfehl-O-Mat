# frozen_string_literal: true
<<<<<<< HEAD

=======
>>>>>>> 2b9d3cf (🎨  rubocop lint, ignore style/docs check)
class Product < ApplicationRecord
  include Visible
  belongs_to :category

  validates :product, presence: true, length: { minimum: 3 }
  validates :desc, presence: true, length: { minimum: 15 }
end
