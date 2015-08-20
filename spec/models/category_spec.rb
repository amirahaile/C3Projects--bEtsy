require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "model validations" do
    context "name" do
      it "is required" do
        category = build :category, name: nil
        category.valid?
        expect(category.errors.keys).to include(:name)
      end

      it "is unique" do
        create :category
        same_category = build :category, name: "Hats"
        same_category.valid?
        expect(same_category.errors.messages).to eq(:name => ["has already been taken"])
      end
    end
  end
end
