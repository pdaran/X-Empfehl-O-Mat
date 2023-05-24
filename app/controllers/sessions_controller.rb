# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])

    if valid_user?(user, params[:password])
      handle_successful_login(user)
    else
      handle_failed_login
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: t('session.notice_delete')
  end

  private

  def valid_user?(user, password)
    user&.authenticate(password)
  end

  def handle_successful_login(user)
    session[:user_id] = user.id
    redirect_to root_path, notice: t('session.notice_create')
  end

  def handle_failed_login
    flash.now[:alert] = t('session.false_login')
    render :new, status: 422
  end
end
