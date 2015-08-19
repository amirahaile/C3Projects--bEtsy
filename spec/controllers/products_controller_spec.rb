require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  # INDEX ACTION__________________________________________________________________

  describe "GET #index" do

    it "renders the index template" do
      get :index

      expect(response).to render_template("index")
    end
  end

  # SHOW ACTION__________________________________________________________________

  describe "GET #show" do
    before :each do
      @product = Product.create(name: 'product', price: 10, user_id: 1, stock: 1,
                                weight: 5, height: 3.4, width: 4.6, length: 3)
    end

    it "returns successfully with an HTTP 200 status code" do
      get :show, id: @product

      expect(response).to be_success
    end

    it "renders the show view" do
      get :show, id: @product

      expect(response).to render_template("show")
    end
  end

  # NEW ACTION__________________________________________________________________

  describe "GET #new" do
    before :each do
      @user = User.create(name: "vikushonok", email: "vika@email.com", password_digest: "VerySmartPassword",
                          address: "8135 Devonshire Drive", city: "Oakland Gardens", state: "NY", zip: "11364")
      session[:user_id] = @user.id
    end

    it "renders the new view" do
      get :new, user_id: @user

      expect(response).to render_template("new")
    end
  end

  # CREATE ACTION__________________________________________________________________

  describe "POST #create" do
    context "valid params" do
      before :each do
        @user = User.create(name: "vikushonok", email: "vika@email.com", password_digest: "VerySmartPassword",
                            address: "8135 Devonshire Drive", city: "Oakland Gardens", state: "NY", zip: "11364")
        session[:user_id] = @user.id
        @product = Product.new(product_params[:product])
      end

        let(:product_params) do
          {
            product: {
              name: 'product',
              price: 10.99,
              stock: 5,
              user_id: 1,
              weight: 5,
              height: 3.4,
              width: 4.6,
              length: 3
            }
          }
        end

      it "creates a product" do
        post :create, product_params

        expect(Product.count).to eq 1
      end

      it "redirects to the product show page" do
        post :create, product_params

        expect(subject).to redirect_to(product_path(assigns(:product)))
      end

      context "invalid params" do
        before :each do
          @user = User.create(name: "vikushonok2", email: "vika2@email.com", password_digest: "VerySmartPassword",
                              address: "8135 Devonshire Drive", city: "Oakland Gardens", state: "NY", zip: "11364")
          session[:user_id] = @user.id
          @product = Product.new(product_params[:product])
        end

          let(:product_params) do
            {
              product: {
                name: 'product',
                price: 10.99,
                stock: -1,
                user_id: 1,
                weight: 5,
                height: 3.4,
                width: 4.6,
                length: 3
              }
            }
          end

        it "doesn't save a product, if the stock is -1" do
          post :create, product_params

          expect(Product.count).to eq 0
        end

        it "redirects to a new product page" do
          post :create, product_params

          expect(response).to render_template("new")
        end
      end
    end
  end

  # EDIT ACTION__________________________________________________________________

  describe "GET #edit" do
    before :each do
      @user = User.create(name: "vikushonok", email: "vika@email.com", password_digest: "VerySmartPassword",
                          address: "8135 Devonshire Drive", city: "Oakland Gardens", state: "NY", zip: "11364")
      session[:user_id] = @user.id
    end

    it "renders the new view" do
      get :new, user_id: @user

      expect(response).to render_template("new")
    end
  end

  # UPDATE ACTION__________________________________________________________________

  describe "PUT #update" do
    context "valid params" do
      before :each do
        @user = User.create(name: "vikushonok", email: "vika@email.com", password_digest: "VerySmartPassword",
                            address: "8135 Devonshire Drive", city: "Oakland Gardens", state: "NY", zip: "11364")
        session[:user_id] = @user.id
        @product = Product.create(name: 'product', price: 10, user_id: 1, stock: 1,
                                  user_id: 1, weight: 5, height: 3.4, width: 4.6, length: 3)
      end

      let(:product_params) do
        {
          product: {
            name: 'product_changed_name',
            price: 10.99,
            stock: 10,
            user_id: 1,
            weight: 5,
            height: 3.4,
            width: 4.6,
            length: 3
          }
        }
      end

      it "updates a product" do
        put :update, { id: @product.id }.merge(product_params)
        @product.reload

        expect(Product.find(1).name).to eq 'product_changed_name'
      end

      it "redirects to merchant product show page" do
        put :update, { id: @product.id }.merge(product_params)
        @product.reload

        expect(response).to redirect_to(user_path(@product.user_id))
      end
    end

    context "invalid product params" do
      before :each do
        @user = User.create(name: "vikushonok", email: "vika@email.com", password_digest: "VerySmartPassword",
                            address: "8135 Devonshire Drive", city: "Oakland Gardens", state: "NY", zip: "11364")
        session[:user_id] = @user.id
        @product = Product.create(name: 'product', price: 10, user_id: 1, stock: 1,
                                  user_id: 1, weight: 5, height: 3.4, width: 4.6, length: 3)
      end

      let(:product_params) do
        {
          product: {
            name: "",
            price: 10.99,
            stock: 10,
            user_id: 1,
            weight: 5,
            height: 3.4,
            width: 4.6,
            length: 3
          }
        }
      end

      it "doesn't update the product" do
        put :update, { id: @product.id }.merge(product_params)
        @product.reload

        expect(@product.name).to eq 'product'
      end

      it "redirects to the edit page " do
        put :update, { id: @product.id }.merge(product_params)
        @product.reload

        expect(response).to render_template("edit", session[:user_id])
      end
    end
  end

  # RETIRE ACTION__________________________________________________________________

  describe "PATCH#retire" do

    before :each do
      @user = User.create(name: "vikushonok", email: "vika@email.com", password_digest: "VerySmartPassword",
                          address: "8135 Devonshire Drive", city: "Oakland Gardens", state: "NY", zip: "11364")
      session[:user_id] = @user.id
      @product = Product.create(name: 'product', price: 10, user_id: 1, stock: 1,
                                weight: 5, height: 3.4, width: 4.6, length: 3)
    end

    it "retires product and redirects to the merchant product page " do
      patch :retire, { id: @product.user_id }
      @product.reload

      expect(response).to redirect_to(user_path(@product.user_id))
      expect(@product.retired).to eq(true)
    end
  end

  # MERCHANT_PRODUCTS ACTION__________________________________________________________________

  describe "GET#merchant_products" do

    before :each do
      @user = User.create(name: "vikushonok", email: "vika@email.com", password_digest: "VerySmartPassword",
                          address: "8135 Devonshire Drive", city: "Oakland Gardens", state: "NY", zip: "11364")
      session[:user_id] = @user.id
    end

    it "renders merchant products page " do
      get :merchant_products, { id: @user.id }

      expect(response).to render_template("merchant_products", session[:user_id])
    end
  end

end
