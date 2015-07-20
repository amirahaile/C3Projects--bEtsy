class ReviewsController < ApplicationController

  def new
    @review = Review.new
    @review.product_id = params[:product_id].to_i
    # Is there a better way to pass on params...? - Brandi
  end

  def create
    @review = Review.new(permit_params)

    if @review.save
      redirect_to product_path(@review.product_id)
    else
      raise
      render :new
    end
  end

  private

  def permit_params
    params.require(:review).permit(:rating, :description, :product_id)
  end
end
