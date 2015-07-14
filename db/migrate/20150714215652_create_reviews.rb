class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating, null: false
      t.string :description
      t.integer :product_id, null: false
      t.timestamps null: false
    end
  end
end
