# frozen_string_literal: true

class PasswordsController < ApplicationController
  def edit_user; end
  def edit_shop; end

  def edit
    @user = User.find_by(password_reset_token: params[:token])
    @shop = Shop.find_by(password_reset_token: params[:token])

    if @user || @shop
      render :edit
    else
      redirect_to root_path, alert: 'Invalid or expired password reset token.'
    end
  end

  def update
    @user = User.find_by(password_reset_token: params[:token])
    @shop = Shop.find_by(password_reset_token: params[:token])

    if @user&.authenticate_reset_token(params[:token])
      update_password(@user)
    elsif @shop&.authenticate_reset_token(params[:token])
      update_password(@shop)
    else
      redirect_to root_path, alert: 'Invalid or expired password reset token.'
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
      redirect_to root_path, alert: 'Password reset token has expired. Please request a new one.'
    elsif resource.update(password: params[:password], password_confirmation: params[:password_confirmation])
      redirect_to root_path, notice: 'Password has been reset successfully.'
    else
      flash.now[:alert] = 'Unable to reset password. Please try again.'
      render :edit
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
