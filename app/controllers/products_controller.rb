# frozen_string_literal: true
<<<<<<< HEAD

=======
>>>>>>> 2b9d3cf (🎨  rubocop lint, ignore style/docs check)
class ProductsController < ApplicationController
  def create
    @category = Category.find(params[:category_id])
    @product = @category.products.create(product_params)
    redirect_to category_path(@category)
  end
<<<<<<< HEAD

  def destroy
    @category = Category.find(params[:category_id])
    @product = @category.products.find(params[:id])
    @product.destroy
    redirect_to category_path(@category), status: :see_other
  end

  private

=======

  def destroy
    @category = Category.find(params[:category_id])
    @product = @category.products.find(params[:id])
    @product.destroy
    redirect_to category_path(@category), status: :see_other
  end

  private

>>>>>>> 2b9d3cf (🎨  rubocop lint, ignore style/docs check)
  def product_params
    params.require(:product).permit(:product, :desc, :status)
  end
end
