require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  context "items are in your cart" do
    before :each do
      order = Order.create

      product1 = Product.create(name: "product1", price: 20.22, photo_url: "www.example.com", inventory: 20, user_id: 1)
      product2 = Product.create(name: "product2", price: 46.12, photo_url: "www.example.com", inventory: 20, user_id: 1)
      product3 = Product.create(name: "product3", price: 25.32, photo_url: "www.example.com", inventory: 20, user_id: 1)

      orderItem1 = OrderItem.create(quantity: 1, order_id: 1, product_id: 1)
      @orderItem2 = OrderItem.create(quantity: 1, order_id: 1, product_id: 2)
      orderItem3 = OrderItem.create(quantity: 1, order_id: 1, product_id: 3)
    end

    # describe "an OrderItem can be removed" do
    # end

    it "increases the quantity of an OrderItem by 1" do
      original_qty = @orderItem2.quantity
      post :qty_increase, id: 2
      @orderItem2.reload

      expect(@orderItem2.quantity).to eq original_qty + 1
    end

    it "decreases the quantity of an OrderItem by 1" do
      original_qty = @orderItem2.quantity
      post :qty_decrease, id: 2
      @orderItem2.reload

      expect(@orderItem2.quantity).to eq original_qty - 1
    end
  end
end
