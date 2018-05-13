class CategoriesController < ApplicationController
  # GET /categories
  def index
    @categories = Category.all

    render json: @categories
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      render json: @category, status: :created
    else
      render json: { errors: @category.errors }, status: :unprocessable_entity
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def category_params
    params.require(:category).permit(:name)
  end
end
