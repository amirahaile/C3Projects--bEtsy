require 'rails_helper'

RSpec.describe User, type: :model do
  describe "model validations" do
    context "username validations" do
      it "requires a username" do
        user = User.new(email: "an_email.com", password: "password", password_confirmation: "password")
        expect(user).to_not be_valid
        expect(user.errors.keys).to include(:username)
      end
    end

    context "email validations" do
      it "requires the presence of an email" do
        user = User.new
        expect(user).to_not be_valid
        expect(user.errors.keys).to include(:email)
      end

      it "requires an email to include '@' and '.'" do
        user = User.new(username: "aname", email: "something.com", password: "password", password_confirmation: "password")
        expect(user).to_not be_valid
        expect(user.errors.keys).to include(:email)
      end
    end

    context "password validations" do
      it "requires a password" do
        user = User.new
        expect(user).to_not be_valid
        expect(user.errors.keys).to include(:password)
      end

      it "requires the password and password confirmation to match" do
        user = User.new(username: "a_name", email: "hi@email.com", password: "password", password_confirmation: "uhduh")
        expect(user).to_not be_valid
        expect(user.errors.keys).to include(:password_confirmation)
      end
    end

    it "requires a city" do
      user = User.new(username: "aname", email: "hi@email.com", password: "password",
        password_confirmation: "password", city: nil, state: "WA", zip: 98101,
        country: "US")
      user.valid?
      expect(user.errors.keys).to include(:city)
    end

    it "requires a state" do
      user = User.new(username: "aname", email: "hi@email.com", password: "password",
        password_confirmation: "password", city: "Seattle", state: nil, zip: 98101,
        country: "US")
      user.valid?
      expect(user.errors.keys).to include(:state)
    end

    it "requires a zip" do
      user = User.new(username: "aname", email: "hi@email.com", password: "password",
        password_confirmation: "password", city: "Seattle", state: "WA", zip: nil,
        country: "US")
      user.valid?
      expect(user.errors.keys).to include(:zip)
    end

    it "requires zip to be a number" do
      user = User.new(username: "aname", email: "hi@email.com", password: "password",
        password_confirmation: "password", city: "Seattle", state: "WA", zip: "abcdef",
        country: "US")
      user.valid?
      expect(user.errors.messages).to include(:zip => ["is not a number"])
    end

    it "requires a country" do
      user = User.new(username: "aname", email: "hi@email.com", password: "password",
        password_confirmation: "password", city: "Seattle", state: "WA", zip: 98101,
        country: nil)
      user.valid?
      expect(user.errors.keys).to include(:country)
    end
  end
end
