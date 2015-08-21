require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it_behaves_like "a show controller"
  it_behaves_like "a new controller"
  it_behaves_like "a create controller"
  let(:user) { create :user }
  let(:params) do # Ugliest params ever...
    {
      valid: {
        user: {
          username: "Testwoman",
          email: "test@testing.com",
          password: "test",
          password_confirmation: "test",
          state: "OH",
          city: "Cincinnati",
          zip: "45206"
        }
      },
      create_user: false,
      nested: false,
      invalid: { user: { username: "" } }
    }
  end

  describe "#new" do
    it "will redirect a signed in user back to the home page" do
      user
      session[:user_id] = 1
      get :new

      expect(subject).to redirect_to(root_path)
    end

    it "throw a flash error if signed in user" do
      user
      session[:user_id] = 1
      get :new

      expect(flash[:alert]).to_not be_empty
    end
  end

end
