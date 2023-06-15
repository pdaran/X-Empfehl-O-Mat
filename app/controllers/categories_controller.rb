# frozen_string_literal: true

class CategoriesController < ApplicationController
  # before_action :require_user_logged_in!
  before_action :set_category, only: %i[show edit update destroy]
  before_action :authorize_shop

  def index
    @categories = @shop.categories.all
  end

  def new
    @category = @shop.categories.build
    # authorize @category
  end

  def create
    @category = @shop.categories.build(category_params)
    # authorize @category
    @input = category_params # for debugging can be removed later
    attach_image if image_present?

    if save_category
      redirect_to shop_categories_path, status: :see_other, notice: t('category.notice_create')
    else
      render :new, status: :unprocessable_entity, alert: t('category.error')
    end
  end

  def update
    if @category.update(category_params)
      redirect_to shop_categories_path, status: :see_other, notice: t('category.notice_update')
    else
      render :edit, status: :unprocessable_entity, alert: t('category.error')
    end
  end

  def destroy
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
      redirect_to shop_categories_path, status: :see_other,
                                        notice: t('category.notice_delete')
    else
      redirect_to shop_categories_path, status: :see_other, alert: t('category.error')
    end
  end
end
