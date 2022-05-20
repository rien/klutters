class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :bank
      t.string :uid
      t.timestamp :valid_until

      t.timestamps
    end
  end
end
