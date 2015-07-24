require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  it_behaves_like "a index controller"
  it_behaves_like "a show controller"
  let(:params) do
    { category: { name: "Test Category" } }
  end
  let(:invalid_params) do
    { category: { name: "" } }
  end
end
