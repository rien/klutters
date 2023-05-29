# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  amount_cents     :integer          default(0), not null
#  amount_currency  :string           default("EUR"), not null
#  description      :string           not null
#  effective_at     :date             not null
#  initiated_at     :datetime
#  other            :string
#  raw_data         :string           not null
#  status           :string           not null
#  transaction_type :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  account_id       :bigint
#
# Indexes
#
#  index_transactions_on_account_id  (account_id)
#
class Transaction < ApplicationRecord
  belongs_to :account

  default_scope { order({effective_at: :desc, id: :desc}) }

  monetize :amount_cents

  validate :initiated_before_effective, if: :initiated_at

  validates :effective_at, presence: true
  validates :raw_data, presence: true
  validates :transaction_type, presence: true
  validates :amount, presence: true, allow_blank: true
  validates :description, presence: true, allow_blank: true
  validates :other, presence: true, allow_blank: true

  def initiated_before_effective
    errors.add(:initiated_at, "can't be after effective_at") if initiated_at.to_date > effective_at
  end
end
