# frozen_string_literal: true

class CategoriesController < SecureController
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = Category.all.order(:sort_order).page(params[:page])
  end

  def show; end

  def update
    if @category.update(category_params)
      redirect_to @category, success: 'Successfully updated category'
    else
      render :edit
    end
  end

  def edit; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to @category, success: 'Successfully created category'
    else
      render :new
    end
  end

  def destroy
    if @category.destroy
      redirect_to categories_path, success: 'Successfully deleted category'
    else
      redirect_to categories_path, {
        error: 'Could not delete category. Please veify there are no channels.'
      }
    end
  end

  private

  def set_category
    @category = Category.includes(:channels).find(params[:id])
  end

  def category_params
    params.require(:category).permit(:title, :slug, :sort_order)
  end
end
