# == Schema Information
#
# Table name: accounts
#
#  id               :bigint           not null, primary key
#  balance_cents    :integer          default(0), not null
#  balance_currency :string           default("EUR"), not null
#  color            :string           not null
#  full_name        :string           not null
#  short_name       :string           not null
#  uid              :string
#  verified         :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  session_id       :bigint
#
# Indexes
#
#  index_accounts_on_session_id  (session_id)
#
class Account < ApplicationRecord
  belongs_to :session
  has_many :transactions

  delegate :active?, :valid_until, :bank, :country, to: :session

  monetize  :balance_cents

  validates :uid, presence: true
  validates :short_name, :full_name, presence:true, allow_blank: true

  def update_balance_with(balances_json)
    bal = balances_json.find { |b| b[:balance_type] == 'XPCD'} || \
          balances_json.find { |b| b[:balance_type] == 'CLBD'} || \
          balances_json.last
    self.balance = parse_money(bal[:balance_amount])
    save
  end

  def update_transactions_with(transactions_json)
    changed = 0

    transactions_json.each do |json|
      transaction = transactions.find_or_initialize_by(reference: json[:entry_reference])
      amount = parse_money(json[:transaction_amount])
      case json[:credit_debit_indicator]
      when "DBIT"
        transaction.amount = amount
      when "CRDT"
        transaction.amount = -amount
      else
        raise "Unrecognised credit_debit_indicator: #{json[:credit_debit_indicator]}"
      end
      transaction.status = json[:status]
      transaction.booked_at = json[:booking_date]
      transaction.description = json[:remittance_information].join("\n")

      if transaction.changed?
        changed += 1
        transaction.save
      end
    end

    changed
  end

  private

  def parse_money(hash)
    (hash[:amount] + hash[:currency]).to_money
  end
end
