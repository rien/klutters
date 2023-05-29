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

FactoryBot.define do
  factory :transaction do
    account
    effective_at { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    incurred_at { Faker::Boolean.boolean ? nil : effective_at - Faker::Number.within(range: 1..48).hours }
    amount_cents { Faker::Number.within(range: -100_00..100_00) }
    amount_currency { "EUR" }
    description { Faker::Lorem.sentence }
    status { "booked" }
    transaction_type { "Betaling Bancontact contactless" }
    raw_data { "fake raw data" }
    counterparty { Faker::Company.name }
    counterparty_account { Faker::Boolean.boolean ? Faker::Bank.iban : nil }
    reference { Faker::Boolean.boolean ? Faker::Number.number(digits: 10) : nil }
  end
end
