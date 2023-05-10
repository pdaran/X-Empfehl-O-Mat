# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale
  before_action :set_current_user

  # fixes category_path and similar functions and forms not adding the locale subdir
  def default_url_options
    { locale: I18n.locale }
  end

  def switch_locale(&)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &)
  end

  private

  def set_locale
    params[:locale] || I18n.default_locale
  end

  def set_current_user
    return unless session[:user_id]

    Current.user = User.find_by(id: session[:user_id])
  end

  def require_user_logged_in!
    return unless Current.user.nil?

    redirect_to sign_in_path,
                alert: 'Du musst angemeldet sein, um diese Funktion nutzen zu können!'
  end
end
