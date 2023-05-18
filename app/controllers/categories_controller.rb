# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
    authorize @category
  end

  def create
    @category = Category.new(category_params)
    authorize @category
    @input = category_params

    if @category.save

      redirect_to action: 'index'

    else

      render :new, status: :unprocessable_entity

    end
  end

  def edit
    @category = Category.find(params[:id])
    authorize @category
  end

  def update
    @category = Category.find(params[:id])
    authorize @category
    if @category.update(category_params)

      redirect_to @category

    else

      render :edit, status: :unprocessable_entity

    end
  end

  def destroy
    @category = Category.find(params[:id])
    authorize @category
    @category.destroy

    redirect_to action: 'index', status: :see_other
  end

  private

  def category_params
    params.require(:category).permit(:title)
  end
end
