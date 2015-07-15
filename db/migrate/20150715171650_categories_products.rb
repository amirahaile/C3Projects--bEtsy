class CategoriesProducts < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.timestamps null: false
    end

    create_table :products do |t|
      t.string :name, null: false
      t.string :description
      t.integer :price, null: false
      t.string :photo_url, null: false
      t.integer :inventory, null: false
      t.string :active, null: false, default: true
      t.integer :user_id, null: false
      t.timestamps null: false
    end

    create_table :categories_products, id: false do |t|
      t.belongs_to :categories, index: true
      t.belongs_to :products, index: true
    end
  end
end
