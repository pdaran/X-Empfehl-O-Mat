# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :require_shop_logged_in!

  def index
    @default_value = 80
  end
end
