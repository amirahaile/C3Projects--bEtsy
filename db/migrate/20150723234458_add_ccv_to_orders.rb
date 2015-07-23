class AddCcvToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :ccv, :string
  end
end
