class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.monetize :amount
      t.string :other
      t.string :reference,    null: false
      t.string :description,  null: false
      t.string :status,       null: false
      t.date   :booked_at,    null: false

      t.references :account

      t.timestamps
    end

    add_index :transactions, [:reference, :account_id]
  end
end
