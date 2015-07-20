require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  before :each do
    @order = Order.create!(email: "hi@hi.com", address1: "123 someplace", city: "somewhere", state: "WA", zipcode: "12345", card_last_4: "1234", card_exp: "10-11")

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
end
