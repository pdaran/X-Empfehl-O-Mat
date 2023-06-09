# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  around_action :switch_locale
  before_action :set_current_user
  before_action :set_current_shop
  before_action :turbo_frame_request_variant

  # fixes category_path and similar functions and forms not adding the locale subdir
  def default_url_options
    { locale: I18n.locale }
  end

  def switch_locale(&)
    locale = params[:locale] || I18n.default_locale
    available_locales = I18n.available_locales.map(&:to_s)
    if available_locales.include?(locale)
      I18n.with_locale(locale, &)
    else
      I18n.with_locale(I18n.default_locale, &)
    end
  end

  def pundit_user
    Current.user
  end

  def pundit_shop
    Current.shop
  end

  private

  def set_locale
    params[:locale] || I18n.default_locale
  end

  def turbo_frame_request_variant
    request.variant = :turbo_frame if turbo_frame_request?
  end

  def set_current_user
    return unless session[:user_id]

    Current.user = User.find_by(id: session[:user_id])
  end

  def set_current_shop
    return unless session[:shop_id]

    Current.shop = Shop.find_by(id: session[:shop_id])
  end

  def require_user_logged_in!
    return unless Current.user.nil?

    redirect_to sign_in_path,
                alert: t('session.nologin')
  end

  def require_shop_logged_in!
    return unless Current.shop.nil?

    redirect_to root_path,
                alert: t('session.nologin')
  end

  def require_user_admin!
    return if session[:user_id] && Current.user.admin?

    redirect_to sign_in_path,
                alert: t('session.noperm')
  end
end
