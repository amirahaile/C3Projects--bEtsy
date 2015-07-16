require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "validations" do

    # how can I test for presence when there's a default value?
    it "defaults :quantity to 1" do
      order_item = OrderItem.new(order_id: 1, product_id: 1)

      expect(order_item.save).to be true
      expect(order_item.quantity).to eq 1
    end

    it "doesn't allow :quantity to be a string" do
      order_item = OrderItem.new(quantity: 'none', order_id: 1, product_id: 1)
      expect(order_item.save).to be false
    end

    it "doesn't allow :quantity to be less than 0" do
      order_item = OrderItem.new(quantity: -10, order_id: 1, product_id: 1)
      expect(order_item.save).to be false
    end
  end
end
