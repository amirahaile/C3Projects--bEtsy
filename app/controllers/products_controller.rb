class ProductsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy, :retire]
  before_action :find_product,  only: [:show, :edit, :update, :destroy, :retire]
  before_action :merchant_exist?, only: [:merchant_products]

  def index
    @products = Product.active_product
  end

  def show
    @order_item = current_order.order_items.new
  end

  def new
    user = User.find(params[:user_id])
    @product = Product.new(user_id: user.id)
  end

  def create
    @product = Product.new(product_params)
    @user_id = session[:user_id]
    if @product.save
      redirect_to product_path(@product)
    else
      render 'new'
    end
  end

  def edit; end

  def update
    @product.update(product_params)

    if @product.save
      redirect_to user_path(@product.user_id)
    else
      render :edit
    end
  end

  def retire
    @product.retire_toggle!
    @product.save
    redirect_to user_path(@product.user_id)
  end

  def merchant_products
    @merchant = @merchants.find(params[:id])
  end

  private

    def find_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(
        :name, :price, :desc, :stock, :photo_url,
        :user_id, :retired, :category_ids => [],
        :categories_attributes => [:id, :name],
        :weight, :width, :height, :length)
    end

    def merchant_exist?
      if User.where(id: params["id"]).any?
        show
      else
        flash[:error] = "This merchant does not exist"
        redirect_to root_path
      end
    end
end
