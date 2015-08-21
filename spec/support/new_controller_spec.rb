require 'spec_helper'

RSpec.shared_examples "a new controller" do

  before :each do
    # Checks to see if you need to create a user & log in.
    # ex. User controller doesn't need to create a user.
    if params[:create_user]
      User.create!(
        username: "Logged In",
        email: "test@test.com",
        password: "test",
        password_confirmation: "test",
        state: "OH",
        city: "Cincinnati",
        zip: "45206"
      )
      session[:user_id] = 1
    end
  end

  describe "#new" do

    it "responds successfully with an HTTP 200 status code" do
      get :new, params[:nested_class]

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it  "renders the #new template" do
      get :new, params[:nested_class]
      expect(subject).to render_template :new
    end
  end

end
