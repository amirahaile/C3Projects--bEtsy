require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "POST #create" do
    let :user do
      { :email => 'b@mail.com', :password => '1234' }
    end
    before(:each) do
      @user = User.create(name: "Beez", email: "b@mail.com", password: "1234", password_confirmation: "1234",
                          address: "8135 Devonshire Drive", city: "Oakland Gardens", state: "NY", zip: "11364")
    end

    it "redirect_to user_path" do
      @user = User.find_by(email: "b@mail.com")
      post :create, session: { :email => 'b@mail.com', :password => '1234' }
      expect(response).to redirect_to(user_path(@user.id))
    end

    it "renders #new if user not found" do
      @user = User.find_by(email: "b@mail.com")
      post :create, session: { :email => "g@mail.com", :password => "1111"}
      expect(response).to render_template(:new)
    end

  end

  describe "DELETE #destroy" do
    before(:each) do
        @user = User.create(name: "Beez", email: "b@mail.com", password: "1234", password_confirmation: "1234",
                            address: "8135 Devonshire Drive", city: "Oakland Gardens", state: "NY", zip: "11364")
        @user =   User.find_by(email: "b@mail.com")
        session[:user_id] = @user.id
      end

    it "redirect_to root_path" do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end

  end # DELETE

end
