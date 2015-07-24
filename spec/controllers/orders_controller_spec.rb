require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  it_behaves_like "a index controller"
  it_behaves_like "a show controller"
  let(:params) do
    {
      valid: {
        order: {
          email: "test@test.com",
          address1: "1 Test",
          address2: "Apt Test",
          city: "Testcity",
          state: "WA",
          zipcode: "55555",
          card_number: "123456789988",
          card_last_4: "6789",
          card_exp: Time.now
        }
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

  describe "order #destroy action" do

    before :each do
      @order = Order.create!(email: "email@email.com", address1: "Some place", city: "somewhere", state: "WA", zipcode: 10000, card_last_4: 1234, card_exp: Time.now, status: "paid")
      @thing = OrderItem.create!(quantity: 2, order_id: 1, product_id: 1)
      @order.order_items << @thing
    end

    it "cancels the order" do
      delete :destroy, id: @order.id
      @order.reload

      expect(@order.status).to eq("cancelled")
    end

    it "redirects appropriately" do
      delete :destroy, id: @order.id
      expect(response).to redirect_to root_path
    end
  end

  # I worked on this for a long time and didn't get it figured out. :( -SM
  # describe "PUT update/:id" do
  #   before :each do
  #     @order = Order.create!(email: "email@email.com", address1: "Some place", city: "somewhere", state: "WA", zipcode: 10000, card_last_4: 1234, card_exp: Time.now, status: "paid")
  #     @thing = OrderItem.create!(quantity: 2, order_id: 2, product_id: 1)
  #     @order.order_items << @thing
  #
  #     put :update, id: @order.id, :order => { email: "mymail@mail.com", city: "Seattle" }
  #     @order.reload
  #   end
  #
  #   it "updates the order record" do
  #     expect(response).to redirect_to(@order)
  #
  #     expect(@order.email).to eq("mymail@mail.com")
  #   end
  #
  #   it "redirects to the order show page" do
  #     expect(subject).to redirect_to order_path(@order)
  #   end
  # end

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

  describe "order status" do
    it "changes from 'pending' to 'paid' after payment info is input" do
      put :update, id: @order.id
      @order.reload
      expect(@order.status).to eq("paid")
    end

    it "redirects to the home page after confirmation" do
      post :update, id: @order.id
      expect(response).to redirect_to(order_confirmation_path(@order))
    end
  end
end
