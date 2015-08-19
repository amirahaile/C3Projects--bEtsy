require 'spec_helper'

RSpec.shared_examples "controller destroy action" do
  # applies to products & order_items

  describe "DELETE #destroy" do

    before :each do
      @object = described_class.model.create(params)
      @user = User.create(username: "user", email: "email@email.com", password: "heloo", password_confirmation: "heloo",
                          city: "Seattle", state: "WA", zip: 98101, country: "US")
      session[session_key] = 1
    end

    it "deletes the record" do
      expect{
        delete :destroy, @path_hash
      }.to change(described_class.model, :count).by(-1)
    end

    it "redirects appropriately" do
      delete :destroy, @path_hash
      expect(response).to redirect_to @path
    end
  end
end
