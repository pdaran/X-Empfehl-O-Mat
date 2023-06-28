# frozen_string_literal: true

class RegistrationsController < ApplicationController
  # before_action :require_user_admin!

  def new_user
    @user = User.new
  end

  def create_user
    @user = User.new(user_params)
    if @user.save
      RegistrationMailer.with(user: @user).signup_email.deliver_later
      redirect_to root_path, notice: t('account.notice_create')
    else
      render :new_user, status: 422
    end
  end

  def new_shop
    @shop = Shop.new
  end

  def create_shop
    @shop = Shop.new(shop_params)
    if @shop.save
      redirect_to redirected_root_path(locale: I18n.locale), notice: t('shop.notice_create')
    else
      Rails.logger.error("Shop creation failed: #{@shop.errors}")
      flash.now[:alert] = t('shop.notice_failed_create')
      render :new_shop, status: 422
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :email, :password, :password_confirmation, :address, :phone_no)
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
