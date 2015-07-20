require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  describe "GET #new" do
    it "responds successfully with an HTTP 200 status code" do
      get :new

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  # describe "POST #create" do
  #   let(:review) { Review.create!(
  #     rating: 1,
  #     description: "This product is LAME!",
  #     product_id: 1
  #     )
  #
  #   context "valid Review params" do
  #     it "creates a Review" do
  #       post :create, params
  #       expect(described_class.model.count).to eq 1
  #     end
  #
  #     #COPIES FROM SALLY'S CODE TO REFRENCE:
  #
  #     it "sets value of rank to 0" do
  #       post :create, params
  #       expect(medium.rank).to eq 0
  #     end
  #
  #     it "redirects to the show page" do
  #       post :create, params
  #       expect(subject).to redirect_to(polymorphic_path(medium))
  #     end
  #
  #     context "record in which only the title is specified" do
  #       it "creates a record" do
  #         post :create, minimal_params
  #         expect(described_class.model.count).to eq 1
  #       end
  #     end
  #   end

end
