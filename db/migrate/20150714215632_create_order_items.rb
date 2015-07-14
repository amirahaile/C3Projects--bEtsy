class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.integer :quantity, null: false
      t.integer :order_id, null: false
      t.integer :product_id, null: false
      t.timestamps null: false
    end
  end
end
