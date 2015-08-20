require 'rails_helper'

RSpec.describe Order, type: :model do

  describe "model validations" do
    it "requires address1" do
      user = build :order, address1: nil
      user.valid?
      expect(user.errors.keys).to include(:address1)
    end

    it "requires city" do
      user = build :order, city: nil
      user.valid?
      expect(user.errors.keys).to include(:city)
    end

    it "requires state" do # There is more to validate than only presence
      user = build :order, state: nil
      user.valid?
      expect(user.errors.keys).to include(:state)
    end

    it "requires zip" do # There is more to validate than only presence
      user = build :order, zip: nil
      user.valid?
      expect(user.errors.keys).to include(:zip)
    end

    it "requires card_exp" do
      user = build :order, card_exp: nil
      user.valid?
      expect(user.errors.keys).to include(:card_exp)
    end

    context "card_last_4 field" do
      it "requires card_last_4" do
        order = build :order, card_last_4: nil
        order.valid?
        expect(order.errors.keys).to include(:card_last_4)
      end

      it "requires 4 characters" do
        order = build :order, card_last_4: 123
        order.valid?
        expect(order.errors.keys).to include(:card_last_4)
      end

      ["1234", "5678", "9012"].each do |valid_card|
        it "only contains characters 0-9" do
          expect(/[0-9]+/.match(valid_card)).to be_a(MatchData)
        end
      end

      ["hihi", "345", 959, 12.3, 12.34].each do |invalid_card|
        it "doesn't validate #{invalid_card} for card_last_4" do
          order = build :order, card_last_4: invalid_card
          order.valid?
          expect(order.errors.keys).to include(:card_last_4)
        end
      end
    end

    context "status field" do
      it "requires status" do
        order = build :order, status: nil
        order.valid?
        expect(order.errors.keys).to include(:status)
      end

      it "status field defaults to 'pending'" do
        order = build :order
        expect(order.status).to eq("pending")
      end

      ["pending", "paid", "complete", "cancelled"].each do |valid_status|
        it "only contains valid statuses" do
          order = build :order, status: valid_status
          expect(order).to be_valid
        end
      end

      ["not awesome", "345", 959, 12.3, 12.34].each do |invalid_status|
        it "does not validate #{invalid_status} for status" do
          order = build :order, status: invalid_status
          order.valid?
          expect(order.errors.messages).to eq(:status => ["#{invalid_status} is not a valid status"])
        end
      end
    end

    context "email" do
      it "requires an email" do
        user = build :order, email: nil
        user.valid?
        expect(user.errors.keys).to include(:email)
      end

      it "requires an email to include '@' and '.'" do
        user = build :order, email: "hello"
        user.valid?
        expect(user.errors.messages).to eq(:email => ["is invalid"])
      end
    end
  end

  describe "scopes" do
    before(:each) do
      # paid
      3.times do
        create :order, status: "paid"
      end

      # pending
      3.times do
        create :order
      end

      @orders = Order.all

      # to give each order a different :created_at value
      @orders.each do |order|
        order[:created_at] = Time.now
      end
    end

    describe "#by_status" do
      it "doesn't allow more or less than two arguments" do
        expect { Order.by_status(@orders) }.to raise_error ArgumentError
        expect { Order.by_status(@orders, 'paid', 'pending') }.to raise_error ArgumentError
        expect { Order.by_status(@orders, 'pending') }.not_to raise_error
      end

      it "only returns orders of the requested status" do
        requested_status = 'paid'
        output = Order.by_status(@orders, requested_status)

        output.each do |order|
          expect(order.status).to eq requested_status
        end
      end

      it "doesn't return nil in place of unmatched orders" do
        output = Order.by_status(@orders, 'pending')
        expect(output).to_not include(nil)
      end

      it "returns an array of Order objects" do
        output = Order.by_status(@orders, 'paid')

        expect(output.class).to be Array
        output.each do |element|
          expect(element.class).to be Order
        end
      end
    end

    describe "#latest_5" do
      it "doesn't allow more or less than one argument" do
        expect { Order.latest_5() }.to raise_error ArgumentError
        expect { Order.latest_5(@orders, 'pending') }.to raise_error ArgumentError
        expect { Order.latest_5(@orders) }.to_not raise_error
      end

      it "returns 5 Order objects" do
        expect(Order.latest_5(@orders).count).to eq 5
        @orders.each do |element|
          expect(element.class).to be Order
        end
      end

      it "returns the most recent orders" do
        output = Order.latest_5(@orders)
        # selects order with oldest created_at timestamp
        oldest_order = @orders.min_by { |order| order if order.created_at }

        expect(output).to_not include oldest_order
      end


      it "returns Order objects in reverse chronological order" do
        # in reverse because we want the last order (largest date) first
        output = Order.latest_5(@orders)
        count = 0

        while output.length < count
          expect(output[count].created_at).to be > output[count + 1].created_at
        end
      end

      it "returns an array of Order objects" do
        output = Order.latest_5(@orders)

        expect(output.class).to be Array
        output.each do |element|
          expect(element.class).to be Order
        end
      end
    end
  end
end
