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

FactoryBot.define do
  factory :transaction do
    account
    effective_at { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    initiated_at { Faker::Boolean.boolean ? nil : effective_at - Faker::Number.within(range: 1..48).hours }
    amount_cents { Faker::Number.within(range: -100_00..100_00) }
    amount_currency { "EUR" }
    description { Faker::Lorem.sentence }
    status { "booked" }
    transaction_type { "Betaling Bancontact contactless" }
    raw_data { "fake raw data" }
    other { Faker::Company.name }
  end
end
