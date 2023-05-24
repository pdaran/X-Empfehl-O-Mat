# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :require_user_logged_in!
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
    authorize @category
  end

  def create
    @category = build_category
    authorize @category
    @input = category_params # for debugging can be removed later
    attach_image if image_present?

    if save_category
      redirect_to categories_path, status: :see_other, notice: t('category.notice_create')
    else
      render :new, status: :unprocessable_entity, alert: t('category.error')
    end
  end

  def edit
    @category = Category.find(params[:id])
    authorize @category
  end

  def update
    @category = Category.find(params[:id])
    authorize @category
    if @category.update(category_params)
      redirect_to categories_path, status: :see_other, notice: t('category.notice_update')
    else
      render :edit, status: :unprocessable_entity, alert: t('category.error')
    end
  end

  def destroy
    @category = Category.find(params[:id])
    authorize @category
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
      redirect_to categories_path, status: :see_other,
                                   notice: t('category.notice_delete')
    else
      redirect_to categories_path, status: :see_other, alert: t('category.error')
    end
  end
end
