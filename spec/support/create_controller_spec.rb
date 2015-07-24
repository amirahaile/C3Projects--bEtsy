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
        if params[:nested]
          post :create, {
            params[:nested_class].keys.first => params[:nested_class].values.first,
            params[:valid].keys.first => params[:valid].values.first
          } # This is so gross. It's working though. Don't have time to make less crazy. - Brandi
            # Basically:
            # ex. post :create, { user_id: 1, product: { name: "Product Name" } }
        else
          post :create, params[:valid]
        end
        expect(described_class.model.count).to eq 1
      end
    end

    context "invalid #{described_class.model} params" do
      it "does not create a #{described_class.model}" do
        if params[:nested]
          post :create, {
            params[:nested_class].keys.first => params[:nested_class].values.first,
            params[:invalid].keys.first => params[:invalid].values.first
          }
        else
          post :create, params[:invalid]
        end
        expect(described_class.model.count).to eq 0
      end

      it "renders the new #{described_class.model} page (if unsuccessful save)" do
        if params[:nested]
          post :create, {
            params[:nested_class].keys.first => params[:nested_class].values.first,
            params[:invalid].keys.first => params[:invalid].values.first
          }
        else
          post :create, params[:invalid]
        end
        expect(subject).to render_template(:new)
      end
    end
  end

end
