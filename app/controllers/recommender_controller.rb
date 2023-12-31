# frozen_string_literal: true

class RecommenderController < ApplicationController
  before_action :kiosk_mode?

  def kiosk_mode?
    redirect_to root_path unless session[:kiosk_mode]
  end

  def products
    @category = Category.find(session[:kiosk_mode_category_id])
    session[:category_id] = session[:kiosk_mode_category_id]
    set_products

    return unless params[:product_ids]

    save_likes
  end

  def result
    require 'net/http'
    require 'uri'

    uri = URI('http://empfehl-flask:8000/recommend')

    customer_id = session[:rec_id]
    category_id = session[:category_id]

    data = {
      customer_id:,
      category_id:
    }

    # http request to url
    response = Net::HTTP.post_form(uri, data)

    response_string = response.body

    # Convert response Json String to Object
    @product_ids = JSON.parse(response_string)
    create_recommendations

    # Find all Products by th ID Array
    find_products

    @user = session[:user_id]

    @recommended_products = find_products

    @recommendation_count = Recommendation.count
  end

  private

  def like_params
    params.require(:product_ids)
  end

  def save_likes
    c = Customer.new
    c.save
    session[:rec_id] = c.id

    like_params.each do |id|
      l = Like.new(like: true, customer_id: c.id, product_id: id)
      l.save
    end
    redirect_to controller: 'recommender', action: 'result'
  end

  def create_recommendations
    @product_ids.each do |p_product_id|
      Recommendation.create(product_id: p_product_id, customer_id: session[:rec_id])
    end
  end

  def find_products
    @products = Product.find(@product_ids)
  end
end
