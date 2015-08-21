require 'rails_helper'

RSpec.describe User, type: :model do
  describe "model validations" do
    it "requires a username" do
      user = build :user, username: nil
      user.valid?
      expect(user.errors.keys).to include(:username)
    end

    context "email validations" do
      it "requires an email" do
        user = build :user, email: nil
        user.valid?
        expect(user.errors.keys).to include(:email)
      end

      it "requires an email to include '@' and '.'" do
        user = build :user, email: "hello"
        user.valid?
        expect(user.errors.messages).to eq(:email => ["is invalid"])
      end
    end

    context "password validations" do
      it "requires a password" do
        user = build :user, password: nil
        user.valid?
        expect(user.errors.keys).to include(:password)
      end

      it "requires the password and password confirmation to match" do
        user = build :user, password_confirmation: "hello"
        user.valid?
        expect(user.errors.messages).to eq(:password_confirmation =>
          ["doesn't match Password", "doesn't match Password"])
      end
    end

    it "requires a city" do
      user = build :user, city: nil
      user.valid?
      expect(user.errors.keys).to include(:city)
    end

    it "requires a state" do
      user = build :user, state: nil
      user.valid?
      expect(user.errors.keys).to include(:state)
    end

    context "zip validations" do
      it "requires a zip" do
        user = build :user, zip: nil
        user.valid?
        expect(user.errors.keys).to include(:zip)
      end

      it "requires zip to be a number" do
        user = build :user, zip: "abc"
        user.valid?
        expect(user.errors.messages).to eq(:zip => ["is not a number"])
      end
    end

    it "requires a country" do
      user = build :user, country: nil
      user.valid?
      expect(user.errors.keys).to include(:country)
    end
  end
end
