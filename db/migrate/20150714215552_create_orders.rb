class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :email
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :name_on_card
      t.string :card_number
      t.string :ccv
      t.string :card_last_4
      t.datetime :card_exp
      t.string :status, null: false, default: "pending"
      t.timestamps null: false
    end
  end
end
