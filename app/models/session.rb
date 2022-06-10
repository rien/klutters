# == Schema Information
#
# Table name: sessions
#
#  id               :bigint           not null, primary key
#  active           :boolean          default(FALSE)
#  bank             :string           not null
#  country          :string           not null
#  link_state_token :string
#  uid              :string
#  valid_until      :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Session < ApplicationRecord
  has_many :accounts, validate: true

  validates :uid, uniqueness: true, allow_nil: true

  def generate_link_state_token!
    begin
      link_state_token = SecureRandom.base58(32)
    end while Session.exists?(link_state_token:)
    update(link_state_token:)
    link_state_token
  end

  def activate_with(json)
    self.uid = json[:session_id]
    self.valid_until = json[:access][:valid_until]
    self.active = true

    json[:accounts].each do |json|
      account = Account.find_or_initialize_by(uid: json[:uid])
      account.name ||= json[:name]
      account.balance_currency = json[:currency]
      self.accounts << account
    end

    save
  end
end
