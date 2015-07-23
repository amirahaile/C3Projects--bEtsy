require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it_behaves_like "index show controller"
  it_behaves_like "a basic new-create controller"
  let(:params) do # Ugliest params ever...
    {
      valid: {
        user: {
          username: "Testwoman",
          email: "test@testing.com",
          password: "test",
          password_confirmation: "test"
        }
      },
      create_user: false,
      invalid: { user: { username: "" } }
    }
  end

  describe "#new" do
    it "will redirect a signed in user back to the home page" do
      User.create!(
        username: "Test",
        email: "test@test.com",
        password: "test",
        password_confirmation: "test"
      )
      session[:user_id] = 1
      get :new

      expect(subject).to redirect_to(root_path)
    end

    it "throw a flash error if signed in user" do
      User.create!(
        username: "Test",
        email: "test@test.com",
        password: "test",
        password_confirmation: "test"
      )
      session[:user_id] = 1
      get :new

      expect(flash[:alert]).to_not be_empty
    end
  end

end
