class ProductsController < ApplicationController
  before_action :load_category, only: [:index, :create]

  # GET /categories/:category_id/products
  def index
    @products = @category.products.all

    render json: @products
  end

  # POST /categories/:category_id/products
  def create
    @product = @category.products.new(product_params)

    if @product.save
      render json: @product, status: :created
    else
      render json: { errors: @product.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /products/:product_id
  def destroy
    @product = Product.find(params[:id])
    @product.destroy
  end

  private

  # Only allow a trusted parameter "white list" through.
  def product_params
    params.require(:product).permit(:name, :price, :category_id)
  end

  def load_category
    @category = Category.find(params[:category_id])
  end
end
