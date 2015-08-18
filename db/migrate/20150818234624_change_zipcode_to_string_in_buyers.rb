class ChangeZipcodeToStringInBuyers < ActiveRecord::Migration
  def change
    change_column :buyers, :billing_zip, :string
  end
end
