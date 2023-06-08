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
       redirect_to redirected_root_path(locale: I18n.locale) ,notice: t('account.notice_create_shop')
      else
        Rails.logger.error("Shop creation failed: #{@shop.errors}")
        render :new_shop, status: 422
      end
  end
  
  def shop_params
      params.require(:shop).permit(:name, :email, :password, :password_confirmation, :address, :phone_no)
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end


