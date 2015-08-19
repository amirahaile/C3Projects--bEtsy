require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  # SHOW and NEW ACTIONS_________________________________________________________________

  describe "GET #show and GET #new" do
    before :each do
      @user = User.create(name: "first_user", email: "name@email.com", password_digest: "foobar",
                          address: "8135 Devonshire Drive", city: "Oakland Gardens", state: "NY", zip: "11364")
      session[:user_id] = @user.id
    end

    it "renders the #show view" do
      get :show, id: @user.id
      expect(response).to render_template("show")
    end

    it "renders the #new view" do
      get :new, user_id: @user
      expect(response).to render_template("new")
    end
  end

  # CREATE ACTION_________________________________________________________________

  describe "POST #create" do

    context "Valid user params" do
      before :each do
        @user = User.new(user_params[:user])
      end

      let(:user_params) do
        {
          user: {
            name: 'second_user',
            email: 'first_user@email.com',
            password: 'ComplicatedPassword',
            password_confirmation: 'ComplicatedPassword',
            address: "8135 Devonshire Drive",
            city: "Oakland Gardens",
            state: "NY",
            zip: "11364"
          }
        }
      end

      it "creates a new user" do
        post :create, user_params
        expect(User.count).to eq 1 # I've created a new user above, so there should be 2
      end

      it "redirects to the user show page" do
        post :create, user_params
        expect(subject).to redirect_to(user_path(assigns(:user)))
      end
    end

    context "Invalid user params" do
      before :each do
        @user = User.new(user_params[:user])
      end

      let(:user_params) do
        {
          user: {
            name: '',
            email: 'third_user@email.com',
            password: 'ComplicatedPassword',
            password_confirmation: 'ComplicatedPassword',
            address: "8135 Devonshire Drive",
            city: "Oakland Gardens",
            state: "NY",
            zip: "11364"
          }
        }
      end

      it "does not persist invalid user" do
        post :create, user_params
        expect(User.count).to eq 0
      end

      it "renders the :new view if the user didn't enter a name" do
        post :create, user_params
        expect(response).to render_template("new")
      end
    end
  end
end
