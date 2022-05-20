# == Schema Information
#
# Table name: accounts
#
#  id          :bigint           not null, primary key
#  bank        :string
#  name        :string
#  uid         :string
#  valid_until :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
