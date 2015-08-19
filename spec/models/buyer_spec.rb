require 'rails_helper'

RSpec.describe Buyer, type: :model do

  describe "model validations " do
    it "requires a name" do
      buyer = build :buyer, name: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:name) #testing that it's failing b/c title is required
    end

    it "requires an email" do
      buyer = build :buyer, email: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:email) #testing that it's failing b/c title is required
    end

    it "requires an billing_address" do
      buyer = build :buyer, billing_address: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:billing_address) #testing that it's failing b/c title is required
    end

    it "requires a billing_zip" do
      buyer = build :buyer, billing_zip: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:billing_zip) #testing that it's failing b/c title is required
    end

    it "requires a billing_state" do
      buyer = build :buyer, billing_state: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:billing_state) #testing that it's failing b/c title is required
    end

    it "requires a billing_city" do
      buyer = build :buyer, billing_city: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:billing_city) #testing that it's failing b/c title is required
    end

    # shipping information skips validation

    it "requires an exp" do
      buyer = build :buyer, exp: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:exp) #testing that it's failing b/c title is required
    end

    it "requires a credit_card" do
      buyer = build :buyer, credit_card: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:credit_card) #testing that it's failing b/c title is required
    end

    it "doesn't validate some word for billing_zip" do # billing_state skips validation
      buyer = build :buyer, billing_zip: "some word"
      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:billing_zip)
    end

    it "doesn't validate WAA for billing_state" do # shipping_state skips validation
      buyer = build :buyer, shipping_state: "WAA", billing_state: "WAA"
      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:billing_state)
    end

    it "doesn't validate 'some word' for credit card" do
      buyer = build :buyer, credit_card: "some word"
      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:credit_card)
    end

    it "email needs an @ sign, all the time" do
      buyer = build :buyer, email: "buyeremail.com"

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:email) #testing that it's failing b/c title is required
    end
  end
end
