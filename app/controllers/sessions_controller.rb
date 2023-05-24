# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: t('session.notice_create')
    else
      flash[:alert] = t('session.false_login')
      render :new, status: 422
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: t('session.notice_delete')
  end
end
