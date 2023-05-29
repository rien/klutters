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
      { effective_date: "2020-08-14", amount: 250_00, counterparty: "Mevr. Alice Alisson", type: "Overschrijving" },
      { effective_date: "2020-08-14", amount: 250_00, counterparty: "Mr. John Johnson", type: "Instantbetaling" },
      { effective_date: "2020-08-14", amount: -50_00, counterparty: "Bernadette Brendottir", type: "Overschrijving" },
      { effective_date: "2020-08-24", amount: 800_00, counterparty: "Mr. John Johnson", type: "Overschrijving" },
      { effective_date: "2020-08-27", amount: -830_00, counterparty: "Mrs. Home Owner", type: "Domiciliëring" },
      { effective_date: "2020-09-01", amount: -64_01, counterparty: "DELHAIZE GENT", type: "Betaling Bancontact" },
      { effective_date: "2020-09-03", amount: -112_87, counterparty: "OKAY GNT", type: "Betaling Bancontact contactless" },
      { effective_date: "2020-09-08", amount: -97_95, counterparty: "IKEA E COMMERCE", type: "eCommerce betaalkaart" },
      { effective_date: "2020-09-08", amount: -7_95, counterparty: "IKEA GENT-STORE", type: "Betaling Maestro" },
      { effective_date: "2020-09-10", amount: -6_75, counterparty: "HEMA EV407 Gent", type: "Betaling Maestro contactless" },
      { effective_date: "2020-09-14", amount: -121_03, counterparty: "INTERNET", type: "Domiciliëring" },
      { effective_date: "2021-01-05", amount: -3_00, counterparty: "Crelan", type: "Beheren vd rek" },
      { effective_date: "2021-06-04", amount: -5_00, counterparty: "Crelan", type: "Kosten niet-uitgevoerde dom." },
      { effective_date: "2021-06-15", amount: -50_00, counterparty: "IZEGEM", type: "Maestro opneming" },
      { effective_date: "2021-07-14", amount: -80_00, counterparty: "Gent", type: "Opneming Bancontact" },
      { effective_date: "2021-07-28", amount: -17_37, counterparty: "Burrido", type: "eCommerce Mobile" },
      { effective_date: "2021-10-01", amount: -5_00, counterparty: "Crelan", type: "Kosten onuitgev. overschr. in euro" },
      { effective_date: "2021-11-03", amount: 7_20, counterparty: "BANKSYS", type: "Storting Banksys" },
      { effective_date: "2022-01-04", amount: -3_50, counterparty: "Crelan", type: "Beheren vd rek Economy Plus Pack" },
      { effective_date: "2022-07-19", amount: 5_00, counterparty: "ATOS WORLDLINE", type: "Terugbetaling transactie debetkaart" },
      { effective_date: "2023-02-06", amount: -666_00, counterparty: "Crelan", type: "Betaling kredietlasten" },
      { effective_date: "2023-04-25", amount: -98_43, counterparty: "4370 OKAY GENT", type: "Uitg. verk. kruid./supermarkt" },
      { effective_date: "2023-04-28", amount: -174_60, counterparty: "FOOD BVBA", type: "Uitg. V. Betaling Winkel" },

    ]

    check_transactions(expected_transactions, transactions)
  end

  def check_transactions(expected, actual)
    expected.each_with_index do |expected_transaction, index|
      actual_transaction = actual[index]
      assert_equal Date.parse(expected_transaction[:effective_date]), actual_transaction.effective_at
      assert_equal Money.new(expected_transaction[:amount]), actual_transaction.amount
      assert_includes actual_transaction.counterparty, expected_transaction[:counterparty]
      assert_includes actual_transaction.transaction_type, expected_transaction[:type]
      if expected_transaction[:initiated_date]
        assert_equal Time.parse(expected_transaction[:initiated_date]), actual_transaction.incurred_at
      end
    end
  end
end
