# frozen_string_literal: true
<<<<<<< HEAD

=======
>>>>>>> 2b9d3cf (🎨  rubocop lint, ignore style/docs check)
class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  validates :title, presence: true, length: { minimum: 3 }
end
