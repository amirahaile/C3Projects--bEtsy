class AddCountryToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :country, :string, default: "US"
    change_column_null :orders, :country, false
  end
end
