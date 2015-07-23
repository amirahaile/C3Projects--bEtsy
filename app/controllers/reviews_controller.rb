class ReviewsController < ApplicationController

  def new
    @product = Product.find(params[:product_id])
    @review = Review.new

    if @product.user_id == session[:user_id]
      # NOTE TO SELF:
      # Flash (NOT FLASH.NOW) is used here because it used in the NEXT request
      # (because of redirect_to) and not in the current request, which Would
      # be the case if I were rendering. - Brandi
      flash[:alert] = "Don't be silly. You can't review your own product!"
      redirect_to product_path(@product)
    else
      render :new
    end
  end

  def create
    @product = Product.find(params[:product_id])
    @review = Review.new(review_params)
    @review.product_id = params[:product_id].to_i

    if @review.save
      flash[:notice] = "Thanks for submitting a review!"
      redirect_to product_path(@product)
    else
      flash.now[:alert] = "Please rate the product."
      render :new
      # Note to self (Brandi):
      # This changes the URL from http://localhost:3000/products/2/reviews/new
      # to http://localhost:3000/products/2/reviews !
      # This is because it's using the 'create' action URL (look at rake routes),
      # but still rendering the new page.
      # Which is why it looks the same but the URL changes.
      # This is just a Rails quirk.
    end
  end

  private

  def self.model
    User
  end # USED FOR RSPEC SHARED EXAMPLES

  def review_params
    params.require(:review).permit(:rating, :description)
  end
end
