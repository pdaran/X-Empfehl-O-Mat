# frozen_string_literal: true

class HomepageController < ApplicationController
  before_action :kiosk_mode?

  def index
    @shop = Current.shop
  end

  def info; end

  def kiosk_mode?
    return unless session[:kiosk_mode]

    redirect_to recommender_path
  end

  # static pages
  def about; end

  def impressum; end

  def contact; end

  def privacy; end

  def faq; end
end
