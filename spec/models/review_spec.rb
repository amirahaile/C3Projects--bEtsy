require 'rails_helper'

RSpec.describe Review, type: :model do

  describe "model validations" do
    let(:review) { Review.new }

    context "validating rating" do
      it "requires a rating" do
        expect(review).to_not be_valid
        expect(review.errors.keys).to include(:rating)
      end

      ["one", 0.0, 4.5, nil].each do |invalid_rating|
        it "requires rating to be an integer" do
          invalid_review = review
          invalid_review.attributes = {
            rating: invalid_rating,
            description: "Tests",
            product_id: 1
          }

          expect(invalid_review).to_not be_valid
          expect(invalid_review.errors.keys).to include(:rating)
        end
      end

      [-5, -1, 0, 6].each do |invalid_rating|
        it "requires rating to be 1 - 5" do
          invalid_review = review
          invalid_review.attributes = {
            rating: invalid_rating,
            description: "Tests",
            product_id: 1
          }

          expect(invalid_review).to_not be_valid
          expect(invalid_review.errors.keys).to include(:rating)
        end
      end
    end

    # context "validating description" do
    #   # NOTHING HERE
    # end

    context "validating product_id" do
      it "requires a product_id" do
        expect(review).to_not be_valid
        expect(review.errors.keys).to include(:product_id)
      end
    end

  end
end
