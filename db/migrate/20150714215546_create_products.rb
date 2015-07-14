class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :description
      t.integer :price, null: false
      t.string :photo_url, null: false
      t.integer :inventory, null: false
      t.integer :user_id, null: false
      t.timestamps null: false
    end
  end
end
