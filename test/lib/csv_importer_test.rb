require "test_helper"

class CSVImporterTest < ActiveSupport::TestCase
  test "should import transactions from CSV" do
    @account = create(:account)
    @importer = Importer::Csv.new(@account)
    transactions = @importer.import(File.open("test/fixtures/files/crelan_export.csv"))
    transactions.each do |transaction|
      transaction.valid?
      assert_empty transaction.errors
    end

    expected_transactions = [
      { effective_date: "2022-03-01", amount: -48_17, other: "OKAY GENT", type: "Bancontact" },
      { effective_date: "2022-03-02", amount: -42_85, other: "PAYCONIQ", type: "eCommerce Mobile" },
      { effective_date: "2022-03-02", amount: -107_83, other: "Eneco Belgium NV", type: "Domiciliëring" },
      { effective_date: "2022-03-02", amount: -3_50, other: "Crelan", type: "Beheren vd rek Economy Plus Pack" },
      { effective_date: "2022-03-03", amount: 2_50, other: "Mevr. Charlotte Parmentier", type: "Overschrijving in uw voordeel" },
      { effective_date: "2022-03-03", amount: -2_50, other: "Dunkin' Brussel", type: "Bancontact" },
      { effective_date: "2022-03-07", amount: -20_00, other: "Jan Janssen", type: "Overschrijving via Crelan Mobile" },
      { effective_date: "2022-03-08", initiated_date: "2022-03-06 19:42", amount: -72_70, other: "Restaurant Diksmuide", type: "Maestro" },
      { effective_date: "2022-03-08", amount: -23_00, other: "Takeaway GENT", type: "Maestro" },
      { effective_date: "2022-03-08", amount: -48_17, other: "OKAY GENT", type: "Bancontact" },
      { effective_date: "2022-03-08", amount: -42_30, other: "PAYCONIQ", type: "eCommerce Mobile" },
    ]

    check_transactions(expected_transactions, transactions)
  end

  def check_transactions(expected, actual)
    expected.each_with_index do |expected_transaction, index|
      actual_transaction = actual[index]
      assert_equal Date.parse(expected_transaction[:effective_date]), actual_transaction.effective_at
      assert_equal Money.new(expected_transaction[:amount]), actual_transaction.amount
      assert_includes actual_transaction.other, expected_transaction[:other]
      assert_includes actual_transaction.transaction_type, expected_transaction[:type]
      if expected_transaction[:initiated_date]
        assert_equal Time.parse(expected_transaction[:initiated_date]), actual_transaction.initiated_at
      end
    end
  end
end
