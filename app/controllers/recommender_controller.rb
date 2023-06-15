# frozen_string_literal: true

class RecommenderController < ApplicationController
  def category
    @categories = Category.all
  end

  def articles
    @category = Category.find(params[:id])
    session[:category_id] = params[:id]
    @products = if search?
                  @category.products.left_outer_joins(:product_attrs).left_outer_joins(:attrs)
                           .where(where_clause).order(Arel.sql(order_clause)).uniq
                else
                  @category.products.all.order(:product)
                end

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

    @product_ids.each do |p_product_id|
      Recommendation.create(product_id: p_product_id, customer_id:)
    end

    # Find all Products by th ID Array
    @products = Product.find(@product_ids)

    @user = session[:user_id]
  end

  private

  def search?
    params[:query].present? || params[:filter].present?
  end

  def order_clause
    ret = if params[:orderby].present? && params[:orderby] != t('attr.name')
            "CASE attrs.name WHEN '#{params[:orderby]}' THEN 1 END, product_attrs.float_val"
          else
            'products.product'
          end

    ret += ' DESC NULLS LAST' if params[:order].present? && params[:order] == 'desc'

    ret
  end

  def where_clause
    ret = ['(products.product LIKE :q OR products.desc LIKE :q OR product_attrs.value ' \
           'LIKE :q OR product_attrs.float_val::varchar LIKE :q ' \
           'OR CONCAT(attrs.name, attrs.unit) LIKE :q)',
           { q: "%#{params[:query]}%" }]

    if params[:filter].present? && params[:filter] != t('none')
      ret[0] += ' AND (attrs.name = :f)'
      ret[1][:f] = params[:filter]
    end

    ret
  end

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
