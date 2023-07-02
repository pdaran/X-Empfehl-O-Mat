# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create_user
    user = User.find_by(email: params[:email])

    if valid_user?(user, params[:password])
      handle_successful_login(user)
    else
      handle_failed_login
    end
  end

  def create_shop
    shop = Shop.find_by(email: params[:email])
    if valid_shop?(shop, params[:password])
      handle_successful_login_shop(shop)
    else
      handle_failed_login_shop
    end
  end

  def destroy_user
    session[:user_id] = nil
    redirect_to root_path, notice: t('session.notice_delete')
  end

  def destroy_shop
    session[:shop_id] = nil
    redirect_to root_path, notice: t('shop.notice_logout')
  end

  private

  def valid_user?(user, password)
    user&.authenticate(password)
  end

  def valid_shop?(shop, password)
    shop&.authenticate(password)
  end

  def disable_kiosk_mode
    session[:kiosk_mode] = false
  end

  def handle_successful_login_shop(shop)
    session[:shop_id] = shop.id
    disable_kiosk_mode
    redirect_to shop_categories_path(shop), notice: t('session.notice_login_shop')
  end

  def handle_successful_login(user)
    session[:user_id] = user.id
    disable_kiosk_mode
    redirect_to root_path, notice: t('session.notice_create')
  end

  def handle_failed_login
    flash.now[:alert] = t('session.false_login')
    render :new_user, status: 422
  end

  def handle_failed_login_shop
    flash.now[:alert] = t('session.false_login')
    render :new_shop, status: 422
  end
end
