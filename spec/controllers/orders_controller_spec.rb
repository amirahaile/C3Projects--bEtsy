require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  before :each do
    @order = Order.create

    product1 = Product.create(name: "product1", price: 20.22, photo_url: "www.example.com", inventory: 20, user_id: 1)
    product2 = Product.create(name: "product2", price: 46.12, photo_url: "www.example.com", inventory: 20, user_id: 1)
    product3 = Product.create(name: "product3", price: 25.32, photo_url: "www.example.com", inventory: 20, user_id: 1)

    @orderItem1 = OrderItem.create(quantity: 1, order_id: 1, product_id: 1)
    @orderItem2 = OrderItem.create(quantity: 1, order_id: 1, product_id: 2)
    @orderItem3 = OrderItem.create(quantity: 1, order_id: 1, product_id: 3)
  end

  describe "#show" do
    it "retrieves all OrderItems associated with the order" do
      get :show, id: 1
      expect(assigns[:order_items].count).to eq 3
    end
  end
end
