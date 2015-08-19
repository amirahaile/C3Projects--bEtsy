class ProductsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy, :merchant]
  before_action :view_active, only: [:index, :by_vendor, :by_category]

  def index
    # @products is defined by view_active
    @user = User.find_by(id: session[:user_id])
  end

  def show
    @product = Product.find(params[:id])
    @product_average = Review.average_rating(params[:id])
    @status = @product.active ? "Active" : "Inactive"
    # moved from OrderItems controller
    # an Order object is required for this view to render
    # is there a better place for it? ApplicationController?
    # (placement affects how cart renders when empty)
    if session[:order_id].nil?
      @order = Order.new
      @order.save(validate: false)

      session[:order_id] = @order.id
    end
  end

  def by_vendor
    if params[:product][:user_id].empty?
      index
    else
      @user = User.find(params[:product][:user_id])
      @products = @products.by_vendor(@user)
    end

    render :index
  end

  def by_category
    if params[:product][:category_id].empty?
      index
    else
      @category = Category.find(params[:product][:category_id])
      @products = @products.by_category(@category)
    end

    render :index
  end

  def merchant
    @products = Product.where(user_id: session[:user_id])
  end

  def new
    @product = Product.new
  end

  def create
    # @user = User.find(params[:user_id])
    @product = Product.new(create_params)
    @product.user_id = params[:user_id]

    if @product.save
      redirect_to root_path, notice: "Product saved!"
    else
      flash.now[:error] = "Could not save product. Please check the information and try again."
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    edit
    @product.update(create_params)

    redirect_to product_path(@product.id)
  end

  def destroy
    edit
    @product.destroy

    redirect_to my_user_products_path(session[:user_id])
  end

  private

  def self.model
    Product
  end # USED FOR RSPEC SHARED EXAMPLES

  def create_params
    params.require(:product).permit(
      :name,
      :description,
      :price,
      :photo_url,
      :inventory,
      :active,
      :user_id,
      :weight_in_gms,
      :length_in_cms,
      :width_in_cms,
      :height_in_cms,
      category_ids: []
    )
  end

end
