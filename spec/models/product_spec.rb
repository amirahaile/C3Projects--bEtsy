require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "model validations" do
    # Required attributes
    required_attributes = [ "name", "price", "photo_url", "inventory",
      "user_id" ]
    required_attributes.each do |attribute|
      it "requires #{attribute}" do
        product = Product.new
        expect(product).to_not be_valid
        expect(product.errors.keys).to include(attribute.to_sym)
      end
    end

    before :each do
      @product_a = Product.create(
        name: "A product",
        price: 20.95,
        photo_url: "a_photo.jpg",
        inventory: 4,
        user_id: 1
      )
      @product_b = Product.new(
        name: "A product",
        price: 21.95,
        photo_url: "b_photo.jpg",
        inventory: 2,
        user_id: 2
      )
    end
    # Name attribute
    it "name must be unique" do

      expect(@product_b).to_not be_valid
      expect(@product_b.errors.keys).to include(:name)
    end

    # Price attribute
    it "price is a decimal" do
      expect(@product_a.price.class).to eq BigDecimal
    end

    it "does not allow non-numeric input for price" do
      product_c = Product.new(
        name: "C product",
        price: "bloop",
        photo_url: "c_photo.jpg",
        inventory: 22,
        user_id: 2
      )
      expect(product_c).to_not be_valid
      expect(product_c.errors.keys).to include(:price)
    end

    it "non-decimals are converted to decimals by adding .0" do
      product_c = Product.new(
        name: "C product",
        price: 30,
        photo_url: "c_photo.jpg",
        inventory: 22,
        user_id: 2
      )
      expect(product_c.price.to_s).to eq "30.0"
    end

    it "price must be greater than 0" do
      product_c = Product.new(
        name: "C product",
        price: -30.95,
        photo_url: "c_photo.jpg",
        inventory: 22,
        user_id: 2
      )
      expect(product_c).to_not be_valid
      expect(product_c.errors.keys).to include(:price)
    end

    # Inventory attribute
    invalid_inventories = [ -4, 4.53, "bloop" ]
    it "does not allow invalid input for inventory" do
      invalid_inventories.each do |value|
        product = Product.new(
          name: "a product",
          price: 34.20,
          photo_url: "c_photo.jpg",
          inventory: value,
          user_id: 2
        )
        expect(product).to_not be_valid
        expect(product.errors.keys).to include(:inventory)
      end
    end

    it "inventory is a Fixnum" do
      expect(@product_a.inventory.class).to eq Fixnum
    end

    # OTHERS:
    # active is boolean & defaults to true?

    # Testing association
    # it "Product must belong to a User" do
    #   user = User.create(username: "a_user", email: "user@user.com", password: "userstuff999")
    #   user.products << @product_a
    #   expect(@product_a.user_id).to eq(user.id)
    #   expect(user.products).to include(@product_a)
    # end
  end

  # Scopes - WIP
  describe "scope" do
    before :each do
      @product_b = Product.create(
        name: "B product - different vendor",
        price: 22.95,
        photo_url: "b_photo.jpg",
        inventory: 71,
        user_id: 2
      )
      @product_c = Product.create(
        name: "C product",
        price: 30.00,
        photo_url: "c_photo.jpg",
        inventory: 13,
        user_id: 1
      )

      Product.create(name: "A product", price: 40.05, photo_url: "a_photo.jpg", inventory: 2, user_id: 2)
      Product.create(name: "D product", price: 20.05, photo_url: "d_photo.jpg", inventory: 2, user_id: 2)
      Product.create(name: "E product", price: 30.05, photo_url: "e_photo.jpg", inventory: 2, user_id: 2)
      Product.create(name: "F product", price: 45.05, photo_url: "f_photo.jpg", inventory: 2, user_id: 2)
      Product.create(name: "G product", price: 32.05, photo_url: "g_photo.jpg", inventory: 2, user_id: 2)
    end

    describe "#by_vendor" do
      it "products can be sorted by User (vendor)" do
        products = [@product_a, @product_c]
        products.each do |product|
          expect(Product.by_vendor(1)).to include(product)
        end
        expect(Product.by_vendor(1).count).to eq 2

        expect(Product.by_vendor(2)).to include(@product_b)
        expect(Product.by_vendor(2).count).to eq 1
      end

      it "by_vendor does not return false positives" do
        expect(Product.by_vendor(1)).to_not include(@product_b)
        expect(Product.by_vendor(2)).to_not include(@product_a)
      end
    end

    describe "#by_category" do
      before :each do
        @cat_a = Category.create(name: "Cat")
        @cat_b = Category.create(name: "Dog")
        @cat_c = Category.create(name: "Human")

        @product_a.categories << @cat_a
        @product_b.categories << [@cat_b, @cat_a, @cat_c]
        @product_c.categories << [@cat_a, @cat_c]
      end

      it "categories can be added to a product" do
        expect(@product_a.categories.count).to eq 1
        expect(@product_b.categories.count).to eq 3
        expect(@product_c.categories.count).to eq 2
        expect(@product_c.categories).to include(@cat_a)
      end

      it "a product's categories includes only those assigned" do
        expect(@product_a.categories).to_not include(@cat_c)
      end

      it "products can be sorted by Category" do
        expect(Product.by_category(@cat_a).count).to eq 3
        expect(Product.by_category(@cat_a)).to include(@product_a)

        expect(Product.by_category(@cat_b).count).to eq 1
        expect(Product.by_category(@cat_b)).to include(@product_b)

        expect(Product.by_category(@cat_c).count).to eq 2
        expect(Product.by_category(@cat_c)).to include(@product_c)
      end

      it "by_category scope does not return false positives" do
        expect(Product.by_category(@cat_b)).to_not include(@product_a)
        expect(Product.by_category(@cat_c)).to_not include(@product_a)
      end
    end

    describe "#top_5" do
      before :each do
        @product_ids = []
        Product.all.each do |product|
          @product_ids << product.id
        end

        20.times do
          OrderItem.create(quantity: 1, order_id: 1, product_id: @product_ids.sample)
        end

        @order_items = OrderItem.where(order_id: 1).to_a
        @output = Product.top_5(@order_items)
      end

      it "takes only one argument" do
        expect { Product.top_5() }.to raise_error ArgumentError
        expect { Product.top_5(@order_items, 5) }.to raise_error ArgumentError
        expect { Product.top_5(@order_items) }.to_not raise_error
      end

      # I tried, but I just ended up rewriting the scope
      
      # it "selects the most popular products" do
      #   product1 = @order_items.map { |item| item if item.product_id == 1 }
      #   product2 = @order_items.map { |item| item if item.product_id == 2 }
      #   product3 = @order_items.map { |item| item if item.product_id == 3 }
      #   product4 = @order_items.map { |item| item if item.product_id == 4 }
      #   product5 = @order_items.map { |item| item if item.product_id == 5 }
      #   product6 = @order_items.map { |item| item if item.product_id == 6 }
      #   product7 = @order_items.map { |item| item if item.product_id == 7 }
      #   product_sales = [product1, product2, product3, product4, product5, product6, product7]
      #
      #   least_popular = product_sales.min_by(2) { |sales| sales.count}
      #   print least_popular
      #   unpopular_products = []
      #   least_popular.each do |items|
      #     unpopular_products << Product.find(items[0].product_id)
      #   end
      #
      #   expect(@output).to_not include unpopular_products[0]
      #   expect(@output).to_not include unpopular_products[1]
      # end

      it "returns an array of Product objects" do
        expect(@output.class).to be Array
        @output.each do |element|
          expect(element.class).to be Product
        end
      end

      it "returns 5 objects (inside an Array)" do
        expect(@output.count).to eq 5
      end
    end
  end
end
