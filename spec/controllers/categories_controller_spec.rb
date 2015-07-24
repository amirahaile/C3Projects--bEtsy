require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  it_behaves_like "a new controller"
  it_behaves_like "a create controller"
  let(:params) do
    { valid: { category: { name: "Test Category" } },
      create_user: true,
      nested: false,
      nested_class: {},
      invalid: { category: { name: "" } }
    }
  end
end
