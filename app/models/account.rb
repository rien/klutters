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
class Account < ApplicationRecord
  encrypts :uid
end
