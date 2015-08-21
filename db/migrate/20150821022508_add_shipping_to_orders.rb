class AddShippingToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_price, :float
    add_column :orders, :shipping_type, :string
    add_column :orders, :delivery_date, :string
    add_column :orders, :carrier, :string
  end
end
