# frozen_string_literal: true

class ShopsController < ApplicationController
  before_action :set_shop, only: %i[show edit update destroy]

  def index
    @shops = Shop.order(:name)
  end

  def show; end

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

  def edit; end

  def update
    if @shop.update(shop_params)
      redirect_to shops_path, status: :see_other, notice: t('shop.notice_update')
    else
      render :edit, status: :unprocessable_entity, alert: t('shop.error')
    end
  end

  def destroy
    delete_associated_images
    delete_associated_categories
    handle_shop_deletion
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end

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
    @shop.categories.each do |category|
      category.image.purge
      category.products.each { |product| product.image.purge }
    end
  end

  def delete_associated_categories
    @shop.categories.destroy_all
  end

  def handle_shop_deletion
    if @shop.destroy
      flash[:notice] = t('shop.notice_delete')
    else
      flash[:alert] = t('shop.error')
    end

    redirect_to shops_path, status: :see_other
  end
end
