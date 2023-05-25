# == Schema Information
#
# Table name: sessions
#
#  id               :bigint           not null, primary key
#  active           :boolean          default(FALSE), not null
#  bank             :string           not null
#  country          :string           not null
#  link_state_token :string
#  uid              :string
#  valid_until      :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null


FactoryBot.define do
  factory :session do
    active { true }
    bank { Faker::Bank.name }
    country { Faker::Address.country_code }
    uid { Faker::Internet.uuid }
    valid_until { Time.now + 1.hour }
  end
end
