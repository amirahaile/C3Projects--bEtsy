class AddColumnsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :weight, :float
    add_column :products, :height, :float
    add_column :products, :width, :float
    add_column :products, :depth, :float

    change_column_null :products, :weight, false
    change_column_null :products, :height, false
    change_column_null :products, :width, false
  end
end
