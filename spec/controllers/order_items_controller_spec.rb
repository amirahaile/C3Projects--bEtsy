require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  context "items are in your cart" do
    before :each do
      order = Order.create

      product1 = Product.create(name: "product1", price: 20.22, photo_url: "www.example.com", inventory: 20, user_id: 1, weight_in_gms: 100, length_in_cms: 10, width_in_cms: 5, height_in_cms: 15)
      product2 = Product.create(name: "product2", price: 46.12, photo_url: "www.example.com", inventory: 20, user_id: 1, weight_in_gms: 100, length_in_cms: 10, width_in_cms: 5, height_in_cms: 15)
      product3 = Product.create(name: "product3", price: 25.32, photo_url: "www.example.com", inventory: 20, user_id: 1, weight_in_gms: 100, length_in_cms: 10, width_in_cms: 5, height_in_cms: 15)

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

  describe "delete order item" do
    it_behaves_like "controller destroy action"
    let(:params) do
      { quantity: 2,
        order_id: 1,
        product_id: 1
      }
      end
    let(:session_key) { :order_id }

    before :each do
      @order = Order.create!(email: "email@email.com", address1: "Some place", city: "somewhere", state: "WA", zip: 10000, card_last_4: 1234, card_exp: Time.now, status: "paid")
      @thing = OrderItem.create!(quantity: 2, order_id: 1, product_id: 1)
      @order.order_items << @thing
      @path_hash = { id: @thing.id, order_id: @order.id }
      @path = order_path(@order)
    end
  end

  # describe "DELETE #destroy" do
  #   before(:each) do
  #     @order = Order.create!(email: "email@email.com", address1: "Some place", city: "somewhere", state: "WA", zip: 10000, card_last_4: 1234, card_exp: Time.now, status: "paid")
  #     @thing = OrderItem.create!(quantity: 2, order_id: 1, product_id: 1)
  #     @order.order_items << @thing
  #   end
  #
  #   it "deletes the product from the order" do
  #     delete :destroy, { id: @thing.id, order_id: @order.id }
  #     @order.reload
  #     expect(@order.order_items.length).to eq(0)
  #   end
  #
  #   it "redirects to the order page after deleting an order item" do
  #     delete :destroy, id: @thing.id
  #     expect(response).to redirect_to(order_path(@order.id))
  #   end
  # end
end
