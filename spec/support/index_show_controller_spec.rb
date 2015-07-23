require 'spec_helper'

RSpec.shared_examples "index show controller" do

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it  "renders the #index template" do
      get :index

      expect(subject).to render_template :index
    end
  end

  describe "GET #show" do
    before :each do
      @object = described_class.model.create(params.values.first)
      User.create!(
        username: "Test",
        email: "test@test.com",
        password: "test",
        password_confirmation: "test"
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
