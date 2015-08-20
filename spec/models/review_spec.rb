require 'rails_helper'

RSpec.describe Review, type: :model do

  describe "model validations" do
    context "rating validations" do
      it "requires rating" do
        review = build :review, rating: nil
        review.valid?
        expect(review.errors.keys).to include(:rating)
      end

      ["one", 0.0, 4.5].each do |invalid_rating|
        it "requires rating to be an integer" do
          invalid_review = build :review, rating: invalid_rating
          invalid_review.valid?
          expect(invalid_review.errors.keys).to include(:rating)
        end
      end

      [-1, 0, 6].each do |invalid_rating|
        it "requires rating to be between 1 - 5" do
          invalid_review = build :review, rating: invalid_rating
          invalid_review.valid?
          expect(invalid_review.errors.keys).to include(:rating)
        end
      end
    end

    context "product_id validations" do
      it "requires product_id" do
        review = build :review, product_id: nil
        review.valid?
        expect(review.errors.keys).to include(:product_id)
      end

      ["one", 0.0, 4.5].each do |invalid_id|
        it "requires product_id to be an integer" do
          invalid_review = build :review, rating: invalid_id
          invalid_review.valid?
          expect(invalid_review.errors.keys).to include(:rating)
        end
      end
    end

    context "scopes" do
      before :each do
        rating = ["3", "2", "4", "5", "1"]
        rating.each { |rate| create :review, rating: rate }
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
