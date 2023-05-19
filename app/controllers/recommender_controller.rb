# frozen_string_literal: true

class RecommenderController < ApplicationController
  def category
    @categories = Category.all
  end

  def articles
    @category = Category.find(params[:id])

    if params[:query].present?
      @products = @category.products.where(["product LIKE :query OR desc LIKE :query",  { query: "%#{params[:query]}%" }])
    else
      @products = @category.products.all
    end

    if params[:product_ids]
      save_likes
      return
    end

    if turbo_frame_request?
      render partial: "products", locals: { products: @products }
    else
      render :articles
    end
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
