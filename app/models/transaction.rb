# == Schema Information
#
# Table name: transactions
#
#  id                   :bigint           not null, primary key
#  amount_cents         :integer          default(0), not null
#  amount_currency      :string           default("EUR"), not null
#  counterparty         :string
#  counterparty_account :string
#  description          :string           not null
#  effective_at         :date             not null
#  incurred_at          :datetime
#  raw_data             :string           not null
#  reference            :string
#  status               :string           not null
#  transaction_type     :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  account_id           :bigint
#
# Indexes
#
#  index_transactions_on_account_id                (account_id)
#  index_transactions_on_account_id_and_reference  (account_id,reference) UNIQUE
#
class Transaction < ApplicationRecord
  belongs_to :account

  default_scope { order(Arel.sql('COALESCE(incurred_at, effective_at) DESC'), 'effective_at DESC', 'id DESC') }

  monetize :amount_cents

  validate :incurred_before_effective, if: :incurred_at

  validates :effective_at, presence: true
  validates :raw_data, presence: true
  validates :transaction_type, presence: true
  validates :amount, presence: true, allow_blank: true
  validates :description, presence: true, allow_blank: true
  validates :counterparty, presence: true, allow_blank: true

  def incurred_before_effective
    errors.add(:incurred_at, "can't be after effective_at") if incurred_at.to_date > effective_at
  end
end
