# frozen_string_literal: true

class RegistrationsController < ApplicationController
  #before_action :require_user_admin!

  def new
    @user = User.new
  end

  def new_shop 
    @shop = Shop.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      RegistrationMailer.with(user: @user).signup_email.deliver_later
      redirect_to root_path, notice: t('account.notice_create')
    else
      render :new, status: 422
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :admin, :shop)
  end
end
