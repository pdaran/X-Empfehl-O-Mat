class ShopRegistrationsController < ApplicationController
  before_action
    def new
      @shop = Shop.new
    end
  
    def create
      @shop = Shop.new(shop_params)
      if @shop.save
       redirect_to redirected_root_path(locale: I18n.locale) ,notice: t('account.notice_create_shop')
      else
        Rails.logger.error("Shop creation failed: #{@shop.errors}")
        render :new, status: 422
      end
    end
  
    private
  
    def shop_params
      params.require(:shop).permit(:email, :password, :password_confirmation, :name, :adresse, :telefonnummer, :kontaktperson)
    end
  end
  