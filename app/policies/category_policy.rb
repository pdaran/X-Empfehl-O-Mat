class CategoryPolicy < ApplicationPolicy
  attr_reader :user, :category

  def initialize(user, article)
    @user = user
    @article = article
  end

  def index?
    true
    # if set to false - no one will have access
  end

  def show?
    true
  end

  # Same as for create
  def new?
    create?
  end

  # Same as that of the update.
  def edit?
    update?
  end

  # Only admin is allowed to update the category
  def update?
    user.is_admin
  end

  # Only admin is allowed to create the category
  def create?
    user.is_admin
  end

  def destroy?
    user.is_admin
  end
end