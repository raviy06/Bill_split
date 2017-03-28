class CreateGuests < ActiveRecord::Migration[5.0]
  def change
    create_table :guests do |t|
      t.integer :entry_id
      t.float :amount_paid
      t.float :amount_should_have_paid
      t.integer :user_id

      t.timestamps
    end
  end
end
