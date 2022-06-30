class CreateInitialModels < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.string :uid
      t.string :link_state_token
      t.timestamp :valid_until
      t.string :bank,             null: false
      t.string :country,          null: false
      t.boolean :active,          null: false, default: false

      t.timestamps
    end

    create_table :accounts do |t|
      t.string :uid
      t.string :full_name,      null: false
      t.string :short_name,     null: false
      t.string :color,          null: false
      t.boolean :verified,      null: false, default: false

      t.monetize :balance, null: false

      t.references :session

      t.timestamps
    end
  end
end
