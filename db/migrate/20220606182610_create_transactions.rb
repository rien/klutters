class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.monetize  :amount
      t.string    :reference
      t.string    :counterparty
      t.string    :counterparty_account
      t.string    :raw_data,          null: false
      t.string    :transaction_type,  null: false
      t.string    :description,       null: false
      t.string    :status,            null: false
      t.date      :effective_at,      null: false
      t.datetime  :incurred_at

      t.references :account

      t.index [:account_id, :reference], unique: true

      t.timestamps
    end
  end
end
