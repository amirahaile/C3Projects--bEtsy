class ProductsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]

  def self.model
    Product
  end

  def index
    @products = Product.all
    @user = User.find_by(id: session[:user_id])
    @username = @user ? @user.username : "Guest"
  end

  def show
    @product = Product.find(params[:id])
  end

  def by_vendor
    if params[:product][:user_id].empty?
      @products = Product.all
    else
      @user = User.find(params[:product][:user_id])
      @products = Product.by_vendor(@user)
    end
    render :index
  end

  def by_category
    if params[:product][:category_id].empty?
      @products = Product.all
    else
      @category = Category.find(params[:product][:category_id])
      @products = Product.by_category(@category)
    end
    render :index
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def create_params
    params.require(:product).permit(
      :name,
      :description,
      :price,
      :photo_url,
      :inventory,
      :active
    )
  end

end
