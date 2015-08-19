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

    context "origin (country, state, city, zip) validations" do
      let (:user) { create :user }
      let (:countryless_user) { build :countryless_user }
      origin_fields = [:country, :state, :city, :zip]

      origin_fields.each do |origin_field|
        it "requires a #{origin_field}" do
        user_without_attribute = build :user, origin_field => nil
        expect(user.errors.keys).not_to include(origin_field)
        expect(user_without_attribute).to be_invalid
        end
      end

      it "has a default value of 'US' for country" do
        expect(user.errors.keys).not_to include(:country)
        expect(countryless_user.country).to eq('US')
      end
    end

    context "zip code validations" do
      let (:user) { create :user }

      valid_zips = ["12345", "98019", "02930"]

      valid_zips.each do |valid_zip|
        it "requires a valid 5-digit zip: #{valid_zip}" do
          user.zip = valid_zip
          expect(user).to be_valid
          expect(user.errors.keys).not_to include(:zip)
        end
      end

      invalid_zips = ["9382", "31", "zipco"]

      invalid_zips.each do |invalid_zip|
        it "does not validate an non-5-digit zip: #{invalid_zip}" do
          user.zip = invalid_zip
          expect(user).to be_invalid
          expect(user.errors.keys).to include(:zip)
        end
      end
    end
  end
end
