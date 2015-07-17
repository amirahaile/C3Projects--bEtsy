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
          # binding.pry
          expect(new_order).to_not be_valid
          expect(new_order.errors.keys).to include(:card_last_4)
        end
      end
    end

    context "status field" do
      it "defaults pending" do
        expect(invalid_order.status).to eq("pending")
      end
    end



    # Test status and default should be "pending"!


    # Check card exp must be in the future.

  end
end
