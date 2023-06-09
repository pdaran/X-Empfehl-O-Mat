# frozen_string_literal: true

class HomepageController < ApplicationController
  def index
    @shop = Current.shop
  end

  # static pages
  def about; end

  def impressum; end

  def contact; end

  def privacy; end

  def faq; end
end
