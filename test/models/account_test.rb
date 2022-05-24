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
require "test_helper"

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
