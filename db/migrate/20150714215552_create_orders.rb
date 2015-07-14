class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :email, null: false
      t.string :address1, null: false
      t.string :address2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zipcode, null: false
      t.string :card_last_4, null: false
      t.datetime :card_exp, null: false
      t.timestamps null: false
    end
  end
end
