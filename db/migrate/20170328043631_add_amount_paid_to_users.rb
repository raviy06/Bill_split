class AddAmountPaidToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :amount_paid, :float
  	add_column :users, :amount_should_have_paid, :float
  	add_column :users, :name, :string
  end
end
