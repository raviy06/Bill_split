class RemoveAmountPaidFromUsers < ActiveRecord::Migration[5.0]
  def up
  	remove_column :users, :amount_paid
  	remove_column :users, :amount_should_have_paid
  end

  def down
  	add_column :users, :amount_paid, :float
  	add_column :users, :amount_should_have_paid, :float
  end
end
