class RecommenderController < ApplicationController
  def category
    @categories = Category.all
  end

  def articles
    @category = Category.find(params[:id])

    if params.has_key?(:product_ids)
      c = Customer.new
      c.save
      session[:user_id] = c.id

      like_params.each do |id|
        l = Like.new(like: true, customer_id: c.id, product_id: id.to_i)
        l.save
      end
      redirect_to '/result'
    end
  end

  def result
    @user = session[:user_id]
  end

  private
  def like_params
    params.require(:product_ids)
  end
end
