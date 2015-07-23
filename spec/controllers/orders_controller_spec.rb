require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  it_behaves_like "index show controller"
  let(:params) do
    {
      order: {
        email: "test@test.com",
        address1: "1 Test",
        address2: "Apt Test",
        city: "Testcity",
        state: "WA",
        zipcode: "55555",
        card_number: "123456789",
        card_last_4: "6789",
        card_exp: Time.now
      }
    }
  end

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

  # describe "order status" do
  #   it "changes from 'pending' to 'paid' after payment info is input" do
  #     put :update, id: @order.id
  #     @order.reload
  #     expect(@order.status).to eq("paid")
  #   end
  #
  #   it "redirects to the home page after confirmation" do
  #     post :update, id: @order.id
  #     expect(response).to redirect_to(order_confirmation_path(@order))
  #   end
  # end
end
