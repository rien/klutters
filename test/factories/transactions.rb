# == Schema Information
#
# Table name: transactions
#
#  id              :bigint           not null, primary key
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("EUR"), not null
#  booked_at       :date             not null
#  description     :string           not null
#  other           :string
#  reference       :string           not null
#  status          :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint
#
# Indexes
#
#  index_transactions_on_account_id                (account_id)
#  index_transactions_on_reference_and_account_id  (reference,account_id)

FactoryBot.define do
  factory :transaction do
    account
    reference { Faker::Number.number(digits: 10) }
    booked_at { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    amount_cents { Faker::Number.within(range: -100_00..100_00) }
    amount_currency { "EUR" }
    description { Faker::Lorem.sentence }
    status { "booked" }
    other { Faker::Company.name }
  end
end
