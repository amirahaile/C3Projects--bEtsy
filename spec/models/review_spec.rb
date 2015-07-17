require 'rails_helper'

# These RSpecs are not DRY at all. :(
RSpec.describe Review, type: :model do

  describe "model validations:" do
    let(:review) { Review.new }

    context "rating" do
      it "is required" do
        expect(review).to_not be_valid
        expect(review.errors.keys).to include(:rating)
      end

      ["one", 0.0, 4.5, nil].each do |invalid_rating|
        it "required to be an integer" do
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
        it "required to be 1 - 5" do
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

    context "product_id" do
      it "required" do
        expect(review).to_not be_valid
        expect(review.errors.keys).to include(:product_id)
      end

      ["one", 0.0, 4.5, nil].each do |invalid_id|
        it "required to be an integer" do
          invalid_review = review
          invalid_review.attributes = {
            rating: invalid_id,
            description: "Tests",
            product_id: 1
          }

          expect(invalid_review).to_not be_valid
          expect(invalid_review.errors.keys).to include(:rating)
        end
      end
    end

    context "scopes" do
      before :each do
        rating = ["3", "2", "4", "5", "1"]
        rating.each { |rate| Review.create!(rating: rate, product_id: 1) }
      end

      it "ratings_by_1" do
        expect(Review.ratings_by_1.first).to eq(Review.find(5))
        expect(Review.ratings_by_1.length).to eq(1)
      end

      it "ratings_by_2" do
        expect(Review.ratings_by_2.first).to eq(Review.find(2))
        expect(Review.ratings_by_2.length).to eq(1)
      end

      it "ratings_by_3" do
        expect(Review.ratings_by_3.first).to eq(Review.find(1))
        expect(Review.ratings_by_3.length).to eq(1)
      end

      it "ratings_by_4" do
        expect(Review.ratings_by_4.first).to eq(Review.find(3))
        expect(Review.ratings_by_4.length).to eq(1)
      end

      it "ratings_by_5" do
        expect(Review.ratings_by_5.first).to eq(Review.find(4))
        expect(Review.ratings_by_5.length).to eq(1)
      end
    end
  end
end
