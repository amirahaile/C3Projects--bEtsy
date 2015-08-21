class AddWeightDimensionsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :weight_in_gms, :integer
    add_column :products, :length_in_cms, :integer
    add_column :products, :width_in_cms, :integer
    add_column :products, :height_in_cms, :integer
  end
end
