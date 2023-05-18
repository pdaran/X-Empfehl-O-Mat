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
    @category = build_category
    @input = category_params # for debugging can be removed later
    attach_image if image_present?

    if save_category
      redirect_to categories_path, status: :see_other, notice: 'Category was successfully created.'
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
    delete_associated_images
    delete_associated_products
    handle_category_deletion
  end

  private

  def category_params
    params.require(:category).permit(:title, :image, :status)
  end

  def build_category
    Category.new(category_params)
  end

  def attach_image
    @category.image.attach(params[:category][:image])
  end

  def image_present?
    params.dig(:category, :image).present?
  end

  def save_category
    @category.save
  end

  def delete_associated_images
    @category.image.purge
    @category.products.each { |product| product.image.purge }
  end
  
  def delete_associated_products
    @category.products.destroy_all
  end
  
  def handle_category_deletion
    if @category.destroy
      redirect_to categories_path, status: :see_other, notice: 'Category and associated products were successfully deleted.'
    else
      redirect_to categories_path, status: :see_other, alert: 'Failed to delete the category.'
    end
  end
end
