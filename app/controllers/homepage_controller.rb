# frozen_string_literal: true

class HomepageController < ApplicationController
  before_action :is_kiosk_mode

  def index
    @shop = Current.shop
  end

  def is_kiosk_mode
    if session[:kiosk_mode]
      redirect_to recommender_path
    end
  end

  # static pages
  def about; end

  def impressum; end

  def contact; end

  def privacy; end

  def faq; end
end
