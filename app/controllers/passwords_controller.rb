# frozen_string_literal: true

class PasswordsController < ApplicationController
  def edit_user; end
  def edit_shop; end

  def reset
    @user = User.find_by(password_reset_token: params[:token])
    @shop = Shop.find_by(password_reset_token: params[:token])

    if @user || @shop
      render :reset
    else
      redirect_to root_path, alert: t('password.token_invalid')
    end
  end

  def send_reset
    @user = User.find_by(password_reset_token: params[:token])
    @shop = Shop.find_by(password_reset_token: params[:token])

    if @user&.authenticate_reset_token(params[:token])
      update_password(@user)
    elsif @shop&.authenticate_reset_token(params[:token])
      update_password(@shop)
    else
      redirect_to root_path, alert: t('password.token_invalid')
    end
  end

  def update_user
    if Current.user.update(password_params_user)
      redirect_to root_path, notice: t('password.edit')
    else
      render :edit_user
    end
  end

  def update_shop
    if Current.shop.update(password_params_shop)
      redirect_to edit_shop_path(Current.shop), notice: t('password.edit')
    else
      render :edit_shop
    end
  end

  private

  def update_password(resource)
    if password_reset_expired?(resource)
      redirect_to root_path, alert: t('password.token_invalid')
    elsif resource.update(password: params[:password], password_confirmation: params[:password_confirmation])
      redirect_to root_path, notice: t('password.reset_success')
    else
      flash.now[:alert] = t('password.error')
      render :reset
    end
  end

  def password_reset_expired?(resource)
    resource.password_reset_sent_at < 2.hours.ago
  end

  def password_params_user
    params.require(:user).permit(:password, :password_confirmation)
  end

  def password_params_shop
    params.require(:shop).permit(:password, :password_confirmation)
  end
end
