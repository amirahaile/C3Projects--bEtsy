class ReviewsController < ApplicationController

  def new
    @product = Product.find(params[:product_id])
    @review = Review.new
    # Is there a better way to pass on params...? - Brandi
  end

  def create
    @product = Product.find(params[:product_id])
    @review = Review.new(review_params)
    @review.product_id = params[:product_id].to_i

    if @review.save
      redirect_to product_path(@product)
    else
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

  def review_params
    params.require(:review).permit(:rating, :description)
  end
end
