# == Schema Information
#
# Table name: accounts
#
#  id               :bigint           not null, primary key
#  active           :boolean
#  balance_cents    :integer          default(0), not null
#  balance_currency :string           default("EUR"), not null
#  bank             :string           not null
#  country          :string           not null
#  link_state_token :string
#  name             :string           not null
#  session          :string
#  uid              :string
#  valid_until      :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Account < ApplicationRecord
  validates_presence_of :name, :country, :bank
  monetize  :balance_cents
  encrypts :uid, :session

  def generate_link_state_token
    begin
      new_token = SecureRandom.base58(32)
    end while Account.exists?(link_state_token: new_token)
    update(link_state_token: new_token)
    new_token
  end

  def clear_token
    update(link_state_token: nil)
  end
end
