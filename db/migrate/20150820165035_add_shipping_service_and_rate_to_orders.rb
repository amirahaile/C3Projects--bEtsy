class AddShippingServiceAndRateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_service, :string
    add_column :orders, :shipping_cost, :integer
  end
end
