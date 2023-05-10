# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale

  # fixes category_path and similar functions and forms not adding the locale subdir
  def default_url_options
    { locale: set_locale }
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  private def set_locale
    params[:locale] || I18n.default_locale
  end
end
