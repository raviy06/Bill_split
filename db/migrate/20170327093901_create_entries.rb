class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries do |t|
      t.string :event
      t.datetime :event_date
      t.string :location
      t.integer :total_amount

      t.timestamps
    end
  end
end
