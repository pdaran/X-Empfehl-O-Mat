# frozen_string_literal: true

class ShopsController < ApplicationController
  def index
    @shops = Shop.order(:name)
  end

  def show
    @shop = Shop.find(params[:id])
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = build_shop
    @input = shop_params # for debugging can be removed later
    attach_image if image_present?

    if save_shop
      redirect_to shops_path, status: :see_other, notice: t('shop.notice_create')
    else
      render :new, status: :unprocessable_entity, alert: t('shop.error')
    end
  end

  def edit
    @shop = Shop.find(params[:id])
  end

  def update
    @shop = Shop.find(params[:id])
    if @shop.update(shop_params)
      redirect_to shops_path, status: :see_other, notice: t('shop.notice_update')
    else
      render :edit, status: :unprocessable_entity, alert: t('shop.error')
    end
  end

  def destroy
    @shop = Shop.find(params[:id])
    delete_associated_images
    delete_associated_categories
    handle_shop_deletion
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :email, :password_digest, :address, :phone_no, :image, :status)
  end

  def build_shop
    Shop.new(shop_params)
  end

  def attach_image
    @shop.image.attach(params[:shop][:image])
  end

  def image_present?
    params.dig(:shop, :image).present?
  end

  def save_shop
    @shop.save
  end

  def delete_associated_images
    @shop.image.purge
    @shop.category.each { |category| category.image.purge }
    @shop.category.products.each { |product| product.image.purge }
  end

  def delete_associated_categories
    @shop.category.destroy_all
    @shop.category.products.destroy_all
  end

  def handle_shop_deletion
    if @shop.destroy
      redirect_to shops_path, status: :see_other,
                              notice: t('shop.notice_delete')
    else
      redirect_to shops_path, status: :see_other, alert: t('shop.error')
    end
  end
end
