require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it_behaves_like "index show controller"
  let(:params) do
    {
      user: {
        username: "Testwoman",
        email: "test@testing.com",
        password: "test",
        password_confirmation: "test"
      }
    }
  end

end
