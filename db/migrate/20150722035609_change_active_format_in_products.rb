class ChangeActiveFormatInProducts < ActiveRecord::Migration
  def change
    change_column :products, :active, :boolean, :default => true, :null => false
  end
end
