class AddWeightDimensionsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :weight_in_gms, :decimal, precision: 7, scale: 2
    add_column :products, :length_in_cms, :decimal, precision: 7, scale: 2
    add_column :products, :width_in_cms, :decimal, precision: 7, scale: 2
    add_column :products, :height_in_cms, :decimal, precision: 7, scale: 2
  end
end
