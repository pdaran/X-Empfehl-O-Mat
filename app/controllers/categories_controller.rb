# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @categories = Category.where(status: :active)
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @input = category_params

    if params[:category].present? && params[:category][:image].present?
      # Attach the uploaded image
      @category.image.attach(params[:category][:image])
    end

    if @category.save
      redirect_to categories_path, status: :see_other, notice: 'Product was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])

    if @category.update(category_params)
      redirect_to categories_path, status: :see_other, notice: 'Category was successfully updated.'
    else
      render :edit, status: :unprocessable_entity, alert: 'Failed to update the category.'
    end
  end

  def destroy
    @category = Category.find(params[:id])

    # Delete the associated image attachment asynchronously
    @category.image.purge

    @category.products.each do |product|
      product.image.purge
    end

    if @category.destroy
      redirect_to categories_path, status: :see_other,
                                   notice: 'Category and associated products were successfully deleted.'
    else
      redirect_to categories_path, status: :see_other, alert: 'Failed to delete the category.'
    end
  end

  private

  def category_params
    params.require(:category).permit(:title, :image, :status)
  end
end
