# frozen_string_literal: true

class ProductsController < ApplicationController
  def create
    @category = find_category
    @product = build_product
    attach_image if image_present?

    if save_product
      redirect_to category_path(@category), status: :see_other, notice: t('product.notice_create')
    else
      render :new, status: :unprocessable_entity, alert: t('product.error')
    end
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

      redirect_to category_path(@category), status: :see_other, notice: t('product.notice_update')

    else

      render :edit, status: :unprocessable_entity,
                    alert: t('product.error')

    end
  end

  def destroy
    @category = Category.find(params[:category_id])

    @product = @category.products.find(params[:id])
    # Delete the associated image attachment asynchronously
    @product.image.purge

    if @product.destroy
      redirect_to category_path(@category), status: :see_other, notice: t('product.notice_delete')
    else
      redirect_to category_path(@category), status: :see_other, alert: t('product.error')
    end
  end

  private

  def product_params
    params.require(:product).permit(:product, :desc, :image, :status)
  end

  def find_category
    Category.find(params[:category_id])
  end

  def build_product
    @category.products.build(product_params)
  end

  def attach_image
    @product.image.attach(params[:product][:image])
  end

  def image_present?
    params.dig(:product, :image).present?
  end

  def save_product
    @product.save
  end
end
