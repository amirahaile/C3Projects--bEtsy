require 'spec_helper'

RSpec.shared_examples "a show controller" do

  describe "GET #show" do
    before :each do
      # described_class returns the OrdersController
      # model returns Order so that it reads "Order.create()"
      @object = described_class.model.create(params.values.first.values.first)
      # creates signed in user for shared specs
      User.create!(
        username: "Test",
        email: "test@test.com",
        password: "test",
        password_confirmation: "test",
        city: "Seattle",
        state: "WA",
        zip: 98101,
        country: "US"
      )
      session[:user_id] = 1
    end

    it "responds successfully with an HTTP 200 status code" do
      get :show, id: @object

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it  "renders the #show template" do
      get :show, id: @object
      expect(subject).to render_template :show
    end

    it "shows the selected #{described_class.model}" do
      get :show, id: @object
      expect { assigns(:object).to eq(@object) }
    end
  end

end
