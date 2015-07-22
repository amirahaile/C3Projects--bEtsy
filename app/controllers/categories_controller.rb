class CategoriesController < ApplicationController
  before_action :require_login

  def new
    index
    @category = Category.new
  end

  def create
    @category = Category.create(create_params)
    if @category.save
      redirect_to new_category_path, notice: "Category added!"
    else
      flash.now[:error] = "Could not add category. Are you sure you aren't duplicating a category that already exists?"
      render :new
    end
  end

  def index
    @categories = Category.all
  end

  private

  def create_params
    params.require(:category).permit(:name)
  end
end
