class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name,     null: false
      t.string :bank,     null: false
      t.string :country,  null: false
      t.string :uid
      t.string :session
      t.string :link_state_token
      t.monetize :balance, null: false
      t.boolean :active
      t.timestamp :valid_until

      t.timestamps
    end
  end
end
