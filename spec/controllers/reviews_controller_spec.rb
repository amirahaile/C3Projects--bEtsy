require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

  before(:each) do
    @product = Product.create!(
      name: "The Product",
      price: 20.00,
      photo_url: "a_photo.jpg",
      inventory: 10,
      user_id: 1
    )
  end

  describe "#new" do
    it "responds successfully with an HTTP 200 status code" do
      get :new, {product_id: 1}

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "will redirect the user (merchant) of the product back to the product page" do
      session[:user_id] = @product.user_id
      User.create!(
        username: "Test",
        email: "test@test.com",
        password: "test",
        password_confirmation: "test",
        city: "Seattle",
        state: "WA",
        zip: 98101,
        country: "US"
      )
      get :new, {product_id: 1}

      expect(subject).to redirect_to(product_path(1))
    end
  end

  describe "#create" do
    let(:params) do
      { product_id: 1, review: { rating: 5, description: "Amazing." } }
    end

    let(:empty_params) do
      { product_id: 1, review: { description: "" } }
    end

    let(:invalid_params) do
      { product_id: 1, review: { description: "THERE'S NO RATING HERE! <GASP>"} }
    end

    let(:valid_params) do
      { product_id: 1, review: { rating: 3 }}
    end

    context "valid review params" do
      it "creates a review" do
        post :create, params
        expect(Review.count).to eq 1
      end

      it "creates a review with just a rating (no description)" do
        post :create, valid_params
        expect(Review.count).to eq 1
      end

      it "redirects to the product show page (after successful save)" do
        post :create, params
        expect(subject).to redirect_to(product_path(1))
      end
    end

    context "invalid review params" do
      it "does not create a review" do
        post :create, empty_params
        expect(Review.count).to eq 0
      end

      it "does not create a review with just a description (no rating)" do
        post :create, invalid_params
        expect(Review.count).to eq 0
      end

      it "renders the new review page (if unsuccessful save)" do
        post :create, invalid_params
        expect(subject).to render_template("new")
      end

      it "throw a flash error if review is invalid" do
        post :create, invalid_params
        expect(flash).to_not be_empty
      end
    end
  end

end
