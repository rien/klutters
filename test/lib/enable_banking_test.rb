require 'test_helper'

class EnableBankingTest < ActiveSupport::TestCase
  def setup
    @api = TilisyApi.new(key: Rails.application.credentials[:enablebanking][:key],
                         application_id: Rails.application.credentials[:enablebanking][:applicationId])
  end

  def teardown
    # Do nothing
  end

  test "check application" do
    result = @api.application
    debugger
    assert_not_nil result
  end
end
