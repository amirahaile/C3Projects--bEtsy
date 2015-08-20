require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "validations" do
    it "requires a quantity" do
      order_item = build :order_item
      order_item.valid?
      expect(order_item.errors.keys).to_not include(:quantity)
    end

    it "defaults quantity to 1" do
      order_item = build :order_item
      expect(order_item.quantity).to eq 1
    end

    it "requires quantity to be a number" do
      order_item = build :order_item, quantity: "three"
      order_item.valid?
      expect(order_item.errors.messages).to eq(:quantity => ["is not a number"])
    end

    it "requires quantity to be greater than 0" do
      order_item = build :order_item, quantity: -1
      order_item.valid?
      expect(order_item.errors.messages).to eq(:quantity => ["must be greater than 0"])
    end
  end
end
