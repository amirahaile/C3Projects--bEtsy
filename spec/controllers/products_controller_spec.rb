require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  it_behaves_like "index show controller"
  let(:params) do
    {
      product: {
        name: "A product",
        price: 20.95,
        photo_url: "a_photo.jpg",
        inventory: 4,
        user_id: 1
      }
    }
  end

  describe "delete product" do
    it_behaves_like "controller destroy action"
    let(:params) do
      {
        name: "A product",
        price: 20.95,
        photo_url: "a_photo.jpg",
        inventory: 4,
        user_id: 1
      }
      end

    before :each do
      @path = my_user_products_path(params[:user_id])
    end
  end

  describe "GET #by_vendor" do
    before :each do
      User.create(
        username: "vendor",
        email: "email@email.com",
        password: "password",
        password_confirmation: "password"
        )
      Product.create(
        name: "A product",
        price: 49.95,
        photo_url: "a_photo.jpg",
        inventory: 7,
        user_id: 1
      )
      Product.create(
        name: "B product - different vendor",
        price: 22.95,
        photo_url: "b_photo.jpg",
        inventory: 71,
        user_id: 2
      )
      Product.create(
        name: "C product",
        price: 30.00,
        photo_url: "c_photo.jpg",
        inventory: 13,
        user_id: 1
      )
      @products = Product.all
    end

    it "displays a User's products" do
      products = Product.by_vendor(1)
      params = { product: { user_id: 1 } }
      get :by_vendor, params

      expect(assigns(:products).count).to eq products.count
      expect(products.count).to eq 2
    end
  end

  describe "GET #by_category" do
    before :each do
      cat_a = Category.create(name: "cat a")
      cat_b = Category.create(name: "cat b")
      product_a = Product.create(
        name: "A product",
        price: 49.95,
        photo_url: "a_photo.jpg",
        inventory: 7,
        user_id: 1
      )
      product_a.categories << cat_a
      product_a.categories << cat_b

      product_b = Product.create(
        name: "B product",
        price: 4.95,
        photo_url: "B_photo.jpg",
        inventory: 5,
        user_id: 2
      )
      product_b.categories << cat_a

      @products = Product.all
    end

    it "displays a Category's products" do
      products = Product.by_category(1)
      params = { product: { category_id: 1 } }
      get :by_category, params

      expect(assigns(:products).count).to eq products.count
      expect(products.count).to eq 2
    end
  end

  describe "GET #merchant" do
  end


end
