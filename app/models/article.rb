# frozen_string_literal: true
<<<<<<< HEAD

=======
>>>>>>> 2b9d3cf (🎨  rubocop lint, ignore style/docs check)
class Article < ApplicationRecord
  include Visible

  has_many :comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end
