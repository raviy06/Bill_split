class AddMoneyLentToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :money_lent, :float
  	add_column :users, :money_borrowed, :float
  	add_column :users, :guest, :boolean
  end
end
