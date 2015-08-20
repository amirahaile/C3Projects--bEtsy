class ChangeDimensionDatatypesInOrders < ActiveRecord::Migration
  def change
    change_column :products, :length_in_cms, :integer
    change_column :products, :width_in_cms, :integer
    change_column :products, :height_in_cms, :integer
  end
end
