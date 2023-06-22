# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  # forgot password seite
  def new; end

  def create
    shop = Shop.find_by_email(params[:email])
    shop&.send_password_reset
    flash[:notice] = t('password.notice_send')
    redirect_to root_path
  end

  def edit
    @shop = Shop.find_by_password_reset_token!(params[:id])
  end

  def update
    @shop = Shop.find_by_password_reset_token!(params[:id])
    if token_expired?
      handle_expired_token
    elsif update_shop
      handle_successful_update
    else
      handle_failed_update
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:password)
  end

  def token_expired?
    @shop.password_reset_sent_at < 2.hours.ago
  end

  def handle_expired_token
    flash[:notice] = t('password.token_invalid')
    redirect_to new_password_reset_path
  end

  def update_shop
    @shop.update(shop_params)
  end

  def handle_successful_update
    flash[:notice] = t('password.reset_success')
    redirect_to new_session_path
  end

  def handle_failed_update
    render :edit, alert: t('password.error')
  end
end
