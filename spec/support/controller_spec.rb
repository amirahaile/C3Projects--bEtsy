require 'spec_helper'

RSpec.shared_examples "a controller" do

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
  before :each do
    @object = described_class.model.create(params.values)
  end

  it "shows the selected #{described_class.model}" do
    get :show, id: @object

    expect { assigns(:object).to eq(@object) }
  end

  it  "renders the #show template" do
    get :show, id: @object
    expect(subject).to render_template :show
  end
end


end
