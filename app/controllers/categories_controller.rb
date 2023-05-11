# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @categories = Category.all
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

    if @category.save

      redirect_to action: 'index'

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

      redirect_to @category

    else

      render :edit, status: :unprocessable_entity

    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.products.each do |product|
      product.image.purge # Delete the associated image attachment synchronously
    end

    if @category.destroy
      redirect_to action: 'index', status: :see_other,
                  notice: 'Category and associated products were successfully deleted.'
    else
      redirect_to action: 'index', status: :see_other, alert: 'Failed to delete the category.'
    end
  end

  private

  def category_params
    params.require(:category).permit(:title)
  end
end
