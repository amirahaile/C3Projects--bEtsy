require 'spec_helper'

RSpec.shared_examples "controller destroy action" do
  describe "DELETE #destroy" do
    before :each do
      @object = described_class.model.create(params)
      @user = User.create(username: "user", email: "email@email.com", password: "heloo", password_confirmation: "heloo")

      session[:user_id] = 1
    end

    it "deletes the record" do
      expect{
        delete :destroy, id: @object
      }.to change(described_class.model, :count).by(-1)
    end

    it "redirects to index view" do
      delete :destroy, id: @object
      expect(response).to redirect_to @path
    end
  end
end
