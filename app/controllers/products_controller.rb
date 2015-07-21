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
    # @user = User.find(params[:user_id])
    @product = Product.new(create_params)
    @product.user_id = params[:user_id]
    # Below: Attempt to be able to upload a file, but it doesn't work.
    # I might come back to this later... Would change text_field to file_field
    # new product view

    # if params[:photo_url].present?
    #   file = params[:product][:photo_url]
    #   File.open(Rails.root.join('app','assets', 'images', file), 'wb') do |f|
    #       f.write(file.read)
    #   end
    # end

    # ADD LATER: Flash confirmation?
    if @product.save
      flash[:notice] = "Product saved!"
      redirect_to root_path
    else
      flash[:notice] = "The product was not saved. Try again!"
      redirect_to new_user_product_path
    end
    # raise
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
      :user_id,
      category_ids: []
    )
  end

end
