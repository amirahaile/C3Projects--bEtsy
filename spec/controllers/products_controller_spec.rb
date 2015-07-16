require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  it_behaves_like "a controller"
  let(:params) do
    {
      product: {
        name: "A product",
        price: 20.95,
        photo_url: "a_photo.jpg",
        inventory: 4,
        user_id: 1
      }
    }


  end
end
