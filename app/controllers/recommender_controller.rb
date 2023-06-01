# frozen_string_literal: true

class RecommenderController < ApplicationController
  def category
    @categories = Category.all
  end

  def articles
    @category = Category.find(params[:id])

    @products = if params[:query].present?
                  @category.products.where(['"product" LIKE :query OR "desc" LIKE :query',
                                            { query: "%#{params[:query]}%" }])
                else
                  @category.products.all
                end

    return unless params[:product_ids]

    save_likes
  end

  def result
    require 'net/http'
    require 'uri'

    uri = URI('http://empfehl-flask:8000/recommend')

    customer_id = session[:rec_id]

    data = "{\"id\": #{customer_id}}"

    # http request to url
    response = Net::HTTP.post(uri, data)

    response_string = response.body

    # Convert response Json String to Object
    @product_ids = JSON.parse(response_string)

    # Find all Products by th ID Array
    @products = Product.find(@product_ids)

    @user = session[:user_id]
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
      l = Like.new(like: true, customer_id: c.id, product_id: id.to_i)
      l.save
    end
    redirect_to controller: 'recommender', action: 'result'
  end
end
