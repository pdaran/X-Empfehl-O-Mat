# frozen_string_literal: true

class ProductsController < ApplicationController
  def create
    @shop = Shop.find(params[:shop_id])
    @category = find_category
    @product = build_product
    attach_image if image_present?

    if save_product
      redirect_to shop_category_path(@shop, @category), status: :see_other, notice: t('product.notice_create')
    else
      render :new, status: :unprocessable_entity, alert: t('product.error')
    end
  end

  def new
    @shop = Shop.find(params[:shop_id])
    @category = Category.find(params[:category_id])
    @product = @category.products.build
  end

  def edit
    load_shop_category_product
  end

  def update
    load_shop_category_product

    save_attributes

    if update_product
      redirect_to shop_category_path(@shop, @category), status: :see_other, notice: t('product.notice_update')
    else
      render :edit, status: :unprocessable_entity, alert: t('product.error')
    end
  end

  def destroy
    load_shop_category_product
    @product.image.purge

    if destroy_product
      redirect_to shop_category_path(@shop, @category), status: :see_other, notice: t('product.notice_delete')
    else
      redirect_to shop_category_path(@shop, @category), status: :see_other, alert: t('product.error')
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

  def save_attributes
    saved_ids = []
    i = 0
    params[:attr_id]&.each do |id|
      p = ProductAttr.find_or_initialize_by(product_id: @product.id, attr_id: id)
      p.value = params[:attr_val][i]
      p.save
      i += 1
      saved_ids.append(id)
    end

    params[:check_id]&.each do |id|
      p = ProductAttr.find_or_initialize_by(product_id: @product.id, attr_id: id)
      p.value = 'true'
      p.save
      saved_ids.append(id)
    end

    ProductAttr.where(product_id: @product.id).each do |pattr|
      pattr.destroy unless saved_ids.include?(pattr.attr_id.to_s)
    end
  end

  def save_product
    save_attributes
    @product.save
  end

  def load_shop_category_product
    @shop = Shop.find(params[:shop_id])
    @category = Category.find(params[:category_id])
    @product = @category.products.find(params[:id])
  end

  def update_product
    @product.update(product_params)
  end

  def destroy_product
    @product.destroy
  end
end
