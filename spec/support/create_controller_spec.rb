require 'spec_helper'

RSpec.shared_examples "a create controller" do

  before :each do
    # Checks to see if you need to create a user & log in.
    # ex. User controller doesn't need to create a user.
    if params[:create_user]
      User.create!(
        username: "Logged In",
        email: "test@test.com",
        password: "test",
        password_confirmation: "test"
      )
      session[:user_id] = 1
    end
  end

  describe "#create" do

    context "valid #{described_class.model} params" do
      it "creates a #{described_class.model}" do
        post :create, params[:valid]
        expect(described_class.model.count).to eq 1
      end
    end

    context "invalid #{described_class.model} params" do
      it "does not create a #{described_class.model}" do
        post :create, params[:invalid]
        expect(described_class.model.count).to eq 0
      end

      it "renders the new #{described_class.model} page (if unsuccessful save)" do
        post :create, params[:invalid]
        expect(subject).to render_template(:new)
      end
    end
  end

end
