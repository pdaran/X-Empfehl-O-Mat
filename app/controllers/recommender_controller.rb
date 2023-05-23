# frozen_string_literal: true

class RecommenderController < ApplicationController
  def category
    @categories = Category.all
  end

  def articles
    @category = Category.find(params[:id])

    @products = if params[:query].present?
                  @category.products.where(['product LIKE :query OR desc LIKE :query',
                                            { query: "%#{params[:query]}%" }])
                else
                  @category.products.all
                end

    return unless params[:product_ids]

    save_likes
  end

  def result
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
