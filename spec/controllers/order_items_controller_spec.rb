require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  describe "DELETE #destroy" do
    before(:each) do
      @order = Order.create!(email: "email.com", address1: "Some place", city: "somewhere", state: "WA", zipcode: 10000, card_last_4: 1234, card_exp: Time.now, status: "paid")
      @thing = OrderItem.create!(quantity: 2, order_id: 1, product_id: 1)
      @order.order_items << @thing
    end

    it "deletes the product from the order" do
      delete :destroy, id: @thing.id
      @order.reload
      expect(@order.order_items.length).to eq(0)
    end

    it "redirects to the order page after deleting an order item" do
      delete :destroy, id: @thing.id
      expect(response).to redirect_to(order_path(@order.id))
    end
  end
end
