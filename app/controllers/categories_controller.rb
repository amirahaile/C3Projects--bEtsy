class CategoriesController < ApplicationController
  before_action :require_login

  def new
    @categories = Category.all
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

  private

  def self.model
    Category
  end # USED FOR RSPEC SHARED EXAMPLES

  def create_params
    params.require(:category).permit(:name)
  end
end
