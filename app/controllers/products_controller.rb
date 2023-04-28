# frozen_string_literal: true

class ProductsController < ApplicationController
  def create
    @category = Category.find(params[:category_id])
    @product = @category.products.create(product_params)
    redirect_to category_path(@category)
  end

  def destroy
    @category = Category.find(params[:category_id])
    @product = @category.products.find(params[:id])
    @product.destroy
    redirect_to category_path(@category), status: :see_other
  end

  private

  def product_params
    params.require(:product).permit(:product, :desc, :status)
  end
end
