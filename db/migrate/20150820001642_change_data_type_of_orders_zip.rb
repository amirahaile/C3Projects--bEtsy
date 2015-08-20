class ChangeDataTypeOfOrdersZip < ActiveRecord::Migration
  def change
    change_column :orders, :zip, :integer
  end
end
