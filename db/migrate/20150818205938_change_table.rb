class ChangeTable < ActiveRecord::Migration
  change_table :buyers do |t|
    t.rename :address, :billing_address
    t.rename :city, :billing_city
    t.rename :state, :billing_state
    t.rename :zip, :billing_zip

    t.string  :shipping_address
    t.string  :shipping_city
    t.string  :shipping_state
    t.string :shipping_zip
  end
end
