class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :email
      t.string :address1, null: false
      t.string :address2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zipcode, null: false
      t.string :card_number
      t.string :card_last_4
      t.datetime :card_exp
      t.string :status, null: false, default: "pending"
      t.timestamps null: false
    end
  end
end
