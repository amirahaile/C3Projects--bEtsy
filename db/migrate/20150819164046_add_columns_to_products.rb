class AddColumnsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :weight, :float, default: 32.5
    add_column :products, :height, :float, default: 4.3
    add_column :products, :width, :float, default: 10.0

    change_column_null :products, :weight, false
    change_column_null :products, :height, false
    change_column_null :products, :width, false
  end
end
