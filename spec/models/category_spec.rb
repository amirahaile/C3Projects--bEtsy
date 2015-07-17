require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "model validations" do
    let(:category) { Category.new }

    context "name" do
      it "is required" do
        expect(category).to_not be_valid
        expect(category.errors.keys).to include(:name)
      end

      it "is unique" do
        Category.create!(name: "Hats")
        same_category = Category.new(name: "Hats")
        expect(same_category).to_not be_valid
        expect(same_category.errors.keys).to include(:name)
      end
    end
  end
end
