class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :country, :string, default: "US"
    add_column :users, :state, :string
    add_column :users, :city, :string
    add_column :users, :zip, :string

    change_column_null :users, :country, false
    change_column_null :users, :state, false
    change_column_null :users, :city, false
    change_column_null :users, :zip, false
  end
end
