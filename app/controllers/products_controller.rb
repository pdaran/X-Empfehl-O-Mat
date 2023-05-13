# frozen_string_literal: true

class ProductsController < ApplicationController
  def create
    @category = Category.find(params[:category_id])

    @product = @category.products.create(product_params)

    @product.image.attach(params[:product][:image]) if params[:product].present? && params[:product][:image].present?
    # Attach the uploaded image

    redirect_to category_path(@category)
  end
  def new
    @category = Category.find(params[:category_id])
    @product = @category.products.build
  end
  def edit
    @category = Category.find(params[:category_id])
    @product = @category.products.find(params[:id])
  end

  def update
    @category = Category.find(params[:category_id])

    @product = @category.products.find(params[:id])

    if @product.update(product_params)

      redirect_to category_path(@category), status: :see_other, notice: 'Product was successfully updated.'

    else

      render :edit, status: :unprocessable_entity

    end
  end

  def destroy
    @category = Category.find(params[:category_id])

    @product = @category.products.find(params[:id])

    @product.image.purge # Delete the associated image attachment asynchronously

    if @product.destroy
      redirect_to category_path(@category), status: :see_other, notice: 'Product was successfully deleted.'
    else
      redirect_to category_path(@category), status: :see_other, alert: 'Failed to delete the product.'
    end
  end

  private

  def product_params
    params.require(:product).permit(:product, :desc, :image, :status)
  end
end
