class CategoriesProducts < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    create_table :products do |t|
      t.string :name, null: false
      t.string :description
      t.decimal :price, null: false, scale: 2, precision: 7
      t.string :photo_url, null: false
      t.integer :inventory, null: false
      t.string :active, null: false, default: true
      t.integer :user_id, null: false
      t.timestamps null: false
    end

    create_table :categories_products, id: false do |t|
      t.integer :category_id
      t.integer :product_id
    end
  end
end
