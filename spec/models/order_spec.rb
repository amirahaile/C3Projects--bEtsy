require 'rails_helper'
require 'pry'

RSpec.describe Order, type: :model do

  describe "model validations" do
    let(:invalid_empty_order) { Order.new(status: nil) } # because status defaults to "pending"
    let(:invalid_order) { Order.new }
    let(:valid_order) { Order.new(email: "somedude@someplace.com", address1: "1111 Someplace Ave.", city: "Seattle", state: "WA", zipcode: "55555", card_last_4: "1234", card_exp: Time.new(2017, 11)) }

    required_fields =
      [:email, :address1, :city, :state, :zipcode,
       :card_last_4, :card_exp, :status]

    required_fields.each do |field|
      it "requires #{field}" do
        expect(invalid_empty_order).to_not be_valid
        expect(invalid_empty_order.errors.keys).to include(field)
      end
    end

    context "status field" do
      it "defaults to 'pending'" do
        expect(invalid_order.status).to eq("pending")
      end
    end

    context "card_last_4 field" do
      it "has 4 characters" do
        expect(valid_order.card_last_4.length).to eq(4)
      end

      ["1234", "5678", "9012"].each do |valid_card|
        it "only contains characters 0-9" do
          expect(/[0-9]+/.match(valid_card)).to be_a(MatchData)
        end
      end

      ["hihi", "345", 959, 12.3, 12.34].each do |invalid_card|
        it "doesn't validate #{invalid_card} for card_last_4" do
          new_order = valid_order
          new_order.card_last_4 = invalid_card

          expect(new_order).to_not be_valid
          expect(new_order.errors.keys).to include(:card_last_4)
        end
      end
    end

    context "status field" do
      it "defaults pending" do
        expect(invalid_order.status).to eq("pending")
      end

      ["pending", "paid", "complete", "cancelled"].each do |valid_status|
        it "only contains valid statuses" do
          new_order = valid_order
          new_order.status = valid_status
          expect(new_order).to be_valid
        end
      end

      ["not awesome", "345", 959, 12.3, 12.34].each do |invalid_status|
        it "doesn't validate #{invalid_status} for status" do
          new_order = valid_order
          new_order.status = invalid_status

          expect(new_order).to_not be_valid
          expect(new_order.errors.keys).to include(:status)
        end
      end
    end

    # Test status and default should be "pending"!

    # Check card exp must be in the future.
  end

  describe "scope" do
    before(:each) do
      # paid
      3.times do
        Order.create(email: "example@fake.com", address1: "1234 St", address2: "Apt. A", city: "Plainsville", state: "NA", zipcode: "12345", card_number: nil, card_last_4: "0987", card_exp: "05/06", status: "paid" )
      end

      # pending
      3.times do
        Order.create(email: "example@fake.com", address1: "1234 St", address2: "Apt. A", city: "Plainsville", state: "NA", zipcode: "12345", card_number: nil, card_last_4: "0987", card_exp: "05/06", status: "pending" )
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
