# frozen_string_literal: true

class PasswordsController < ApplicationController
  def edit_user; end
  def edit_shop; end

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

  def password_params_user
    params.require(:user).permit(:password, :password_confirmation)
  end

  def password_params_shop
    params.require(:shop).permit(:password, :password_confirmation)
  end
end
