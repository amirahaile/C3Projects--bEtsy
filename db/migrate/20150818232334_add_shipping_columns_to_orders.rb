class AddShippingColumnsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipper, :string
    add_column :orders, :rate, :integer
    add_column :orders, :service, :string
  end
end
