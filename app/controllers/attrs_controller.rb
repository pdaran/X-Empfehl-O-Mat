class AttrsController < ApplicationController
  before_action :require_user_logged_in!

  def new
    @category = Category.find(params[:category_id])
    @attr = @category.attrs.build
  end

  def create
    @category = Category.find(params[:category_id])
    @attr = @category.attrs.build(attr_params)

    if @attr.save
      redirect_to edit_category_path(@category), status: :see_other, notice: t('attr.notice_create')
    else
      render :new, status: :unprocessable_entity, alert: t('attr.error')
    end
  end

  def edit
    @category = Category.find(params[:category_id])
    @attr = @category.attrs.find(params[:id])
  end

  def update
    @category = Category.find(params[:category_id])
    @attr = @category.attrs.find(params[:id])

    if @attr.update(attr_params)
      redirect_to edit_category_path(@category), status: :see_other, notice: t('attr.notice_update')
    else
      render :edit, status: :unprocessable_entity, alert: t('attr.error')
    end
  end

  def destroy
    @category = Category.find(params[:category_id])
    @attr = @category.attrs.find(params[:id])

    #delete prod_attr
    if @attr.destroy
      redirect_to edit_category_path(@category), status: :see_other, notice: t('attr.notice_delete')
    else
      redirect_to edit_category_path(@category), status: :see_other, alert: t('attr.error')
    end
  end

  private

  def attr_params
    params.require(:attr).permit(:name, :attrtype, :unit)
  end
end