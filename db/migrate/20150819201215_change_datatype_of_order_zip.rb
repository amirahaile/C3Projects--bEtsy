class ChangeDatatypeOfOrderZip < ActiveRecord::Migration
  def change
    rename_column :orders, :zipcode, :zip
  end
end
