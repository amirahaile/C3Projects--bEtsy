require 'rails_helper'
require 'pry'
RSpec.describe OrdersController, type: :controller do

  before :each do
    @order = Order.create!(email: "hi@hi.com", address1: "123 someplace", city: "somewhere", state: "WA", zipcode: "12345", card_last_4: "1234", card_exp: "10-11")

    product1 = Product.create!(name: "product1", price: 5, photo_url: "something.com", inventory: 10, user_id: 1)
    product2 = Product.create!(name: "product2", price: 5, photo_url: "something.com", inventory: 10, user_id: 1)
    product3 = Product.create!(name: "product3", price: 5, photo_url: "something.com", inventory: 10, user_id: 1)

    @orderItem1 = OrderItem.create!(quantity: 1, order_id: 1, product_id: 1)
    @orderItem2 = OrderItem.create!(quantity: 1, order_id: 1, product_id: 2)
    @orderItem3 = OrderItem.create!(quantity: 1, order_id: 1, product_id: 3)
  end

  describe "#show" do
    it "retrieves all OrderItems associated with the order" do
      get :show, id: 1
      expect(assigns[:order_items].count).to eq 3
    end
  end

  describe "order status" do
    it "changes from 'pending' to 'paid' after payment info is input" do
      get :update, id: @order.id
      @order.reload
      binding.pry
      expect(@order.status).to eq("paid")
    end

    it "redirects to the home page after confirmation" do
      post :update, id: @order.id
      expect(response).to redirect_to(order_confirmation_path(@order))
    end
  end
end
