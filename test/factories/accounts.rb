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

FactoryBot.define do
  factory :account do
    session
    uid { Faker::Internet.uuid }
    full_name { "Full Name of #{short_name}" }
    short_name { "Account ##{Faker::Number.within(range: 1..20)}" }
    color { Faker::Color.hex_color }
    verified { true }
  end
end
