# frozen_string_literal: true

class ShopPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    true
  end

  def update?
    manage_shop?
  end

  def destroy?
    manage_shop?
  end

  def manage_shop?
    Current.shop.present? && record.id == Current.shop.id
  end
end
