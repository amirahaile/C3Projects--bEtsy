class ProductsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]

  def self.model
    Product
  end

  def index
    @products = Product.all
    @user = User.find_by(id: session[:user_id])
  end

  def show
    #When logged in, this should only be that user's products
    @product = Product.find(params[:id])
    @product_average = Review.average_rating(params[:id])
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
    @product = Product.new
  end

  def create
    @user = User.find(params[:session][:user_id])
    @product = Product.create(create_params[:product])

    # ADD LATER: Flash confirmation instead?
    if @product.save
      redirect_to product_path(@product.id)
    else
      redirect_to root_path
    end
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
      :active,
      :user_id
    )
  end

end
