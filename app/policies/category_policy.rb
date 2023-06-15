# frozen_string_literal: true

class CategoryPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    manage_categories?
  end

  def update?
    manage_categories?
  end

  def destroy?
    manage_categories?
  end

  private

  def manage_categories?
    Current.shop.present? && record.shop_id == Current.shop.id
  end
end
