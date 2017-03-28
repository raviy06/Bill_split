class CreateSettlements < ActiveRecord::Migration[5.0]
  def change
    create_table :settlements do |t|
      t.integer :payee_id
      t.integer :receiver_id
      t.float :amount_paid

      t.timestamps
    end
  end
end
