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

    # Scopes - WIP
    context "scopes" do
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
      end

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

      context "by_category scope" do
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
    end

  end
end
