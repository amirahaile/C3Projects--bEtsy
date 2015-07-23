require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  it_behaves_like "index show controller"
  it_behaves_like "a basic new-create controller"
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
  let(:params) do # Ugliest params ever...
    {
      product: {
        name: "A product",
        price: 20.95,
        photo_url: "a_photo.jpg",
        inventory: 4,
        user_id: 1
      },
      create_user: true,
      valid: {
        user: {
          username: "Testwoman",
          email: "test@testing.com",
          password: "test",
          password_confirmation: "test"
        }
      },
      invalid: { user: { username: "" } }
    }

  # let(:valid_params) do
  #   {
  #     product: {
  #       name: "A product",
  #       price: 20.95,
  #       photo_url: "a_photo.jpg",
  #       inventory: 4,
  #       user_id: 1
  #     }
  #   }
  # end
  let(:invalid_params) do
    { product: { name: "" } }
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
    end
  end

  context "delete object" do
    it_behaves_like "controller destroy action"
    let(:params) do
      {
        name: "A product",
        price: 20.95,
        photo_url: "a_photo.jpg",
        inventory: 4,
        user_id: 1
      }
    let(:path) { :my_user_products_path }
    end
  end
end
