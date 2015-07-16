require 'rails_helper'

RSpec.describe Order, type: :model do

  describe "model validations" do
    let(:empty_order) do
      Order.new(status: nil) # because status defaults to "pending"
    end

    let(:order) { Order.new }

    fields =
      [:email, :address1, :city, :state, :zipcode,
       :card_last_4, :card_exp, :status]

    fields.each do |field|
      it "requires #{field}" do
        expect(empty_order).to_not be_valid
        expect(empty_order.errors.keys).to include(field)
      end
    end

    context "status field" do
      it "defaults to 'pending'" do
        expect(order.status).to eq("pending")
      end
    end

    context "card_last_4 field" do
      it "has 4 characters" do # STILL EDITING
        new_order = Order.new(card_last_4: "4567")

        expect(card_last_4).to be_valid
      end

      it "only contains characters 0-9" do
        # STILL EDITING
      end

      ["hihi", "345", 959, 12.3, 12.34].each do |invalid_card|
        it "doesn't validate #{invalid_card} for card_last_4" do
          new_order = Order.new(card_last_4: invalid_card)

          expect(new_order).to_not be_valid
          expect(new_order.errors.keys).to include(:card_last_4)
        end
      end
    end

    # Test status and default should be "pending"!

  end
end
