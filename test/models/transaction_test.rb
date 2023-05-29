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
require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should sort by incurred_at, then effective_at, then id" do
    d1 = 20.days.ago
    d2 = 15.days.ago
    d3 = 10.days.ago
    d4 = 5.days.ago

    t1 = create(:transaction, incurred_at: d1.to_time - 40.hours, effective_at: d1)
    t2 = create(:transaction, incurred_at: d3.to_time - 40.hours, effective_at: d3)
    t3 = create(:transaction, incurred_at: d1.to_time - 40.hours, effective_at: d1)
    t4 = create(:transaction, incurred_at: d3.to_time - 40.hours, effective_at: d3)
    t5 = create(:transaction, incurred_at: nil, effective_at: d4)
    t6 = create(:transaction, incurred_at: nil, effective_at: d2)
    t7 = create(:transaction, incurred_at: nil, effective_at: d1)
    t8 = create(:transaction, incurred_at: nil, effective_at: d3)
    t9 = create(:transaction, incurred_at: d1.to_time - 30.hours, effective_at: d1)

    sorted = Transaction.all.to_a.reverse

    assert_equal t1, sorted[0], "t1"
    assert_equal t3, sorted[1], "t3"
    assert_equal t9, sorted[2], "t9"
    assert_equal t7, sorted[3], "t7"
    assert_equal t6, sorted[4], "t6"
    assert_equal t2, sorted[5], "t2"
    assert_equal t4, sorted[6], "t4"
    assert_equal t8, sorted[7], "t8"
    assert_equal t5, sorted[8], "t5"
  end
end
