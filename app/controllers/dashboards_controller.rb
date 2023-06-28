# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :require_shop_logged_in!

  def index
  end

  def recommendation
    @recommendation_count = Recommendation.where(product_id: session[:kiosk_mode_product_ids]).count
    @recommended_products = Product.where(id: session[:kiosk_mode_product_ids])
  end
end
