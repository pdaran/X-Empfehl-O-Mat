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

  def set_products
    @products = if search?
                  @category.products.left_outer_joins(:product_attrs).left_outer_joins(:attrs)
                           .where(where_clause).order(Arel.sql(order_clause)).uniq
                else
                  @category.products.all.order(:product)
                end
  end

  def search?
    params[:query].present? || params[:filter_arr].present? || params[:order] || params[:orderby]
  end

  def order_clause
    ret = if params[:orderby].present? && params[:orderby] != t('attr.name')
            "CASE attrs.name WHEN '#{params[:orderby]}' THEN 1 END, product_attrs.float_val"
          else
            'products.product'
          end

    ret += ' DESC NULLS LAST' if params[:order].present? && params[:order] == 'desc'
    ret
  end

  def where_clause
    ret = ['(products.product ILIKE :q OR products.desc ILIKE :q OR product_attrs.value ' \
           'ILIKE :q OR product_attrs.float_val::varchar LIKE :q ' \
           'OR attrs.name ILIKE :q OR attrs.unit ILIKE :q)',
           { q: "%#{params[:query]}%" }]

    if params[:filter_arr].present?
      params[:filter_arr].each_with_index do |f, i|
        p = "f#{i}"
        ret[0] += ' AND (products.id IN (SELECT product_attrs.product_id FROM product_attrs WHERE ' \
                  "product_attrs.attr_id = :#{p}))"
        ret[1][p] = Attr.find_by(name: f).id
        ret[1].symbolize_keys!
      end
    end

    puts(ret)
    ret
  end

  def set_category
    @category = @shop.categories.find(params[:id])
  end

  def authorize_shop
    authorize @shop, :manage_shop?
  rescue Pundit::NotAuthorizedError, Pundit::NotDefinedError
    redirect_to root_path, alert: I18n.t('shop.not_authorized')
  end

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
    @shop = Current.shop
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
