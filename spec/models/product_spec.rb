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
    it "Product must belong to a User" do
      user = User.create(username: "a_user", email: "user@user.com", password: "userstuff999")
      user.products << @product_a
      expect(@product_a.user_id).to eq(user.id)
      expect(user.products).to include(@product_a)
    end

    # Scopes - WIP
    # it "products can be sorted by User (vendor)" do
    #   expect(Products.by_vendor(1)).to
    # end

  end
end
