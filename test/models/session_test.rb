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
#
require "test_helper"

class SessionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
