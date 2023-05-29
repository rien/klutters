# frozen_string_literal: true
require 'csv'

class Importer::Csv

  def initialize(account)
    @account = account
  end

  def import(file_path)
    CSV.foreach(file_path, headers: true, col_sep: ';').map do |row|
      builder = TransactionBuilder.new(row).build
      new_transaction = Transaction.new(builder.attributes)
      new_transaction.account = @account
      new_transaction
    end
  end
end

class TransactionBuilder
  def initialize(row)
    @row = row
  end

  def attributes
    {
      amount: @amount,
      description: @description,
      effective_at: @effective_at,
      incurred_at: @incurred_at,
      transaction_type: @transaction_type,
      counterparty: @counterparty,
      counterparty_account: @counterparty_account,
      raw_data: @row.to_s
    }
  end

  def build
    @effective_at = Date.strptime(@row["Datum"], "%d/%m/%Y")
    @transaction_type = @row["Type verrichting"]
    @amount = @row["Bedrag"].to_money(@row["Munt"])
    if @amount.nil?
      raise "Could not parse amount: #{@row["Bedrag"]} #{@row["Munt"]}"
    end
    @description = @row["Mededeling"] || ""
    @counterparty = @row["Tegenpartij"]
    @counterparty_account = @row["Rekening tegenpartij"]

    case @transaction_type
    when /Betaling (Bancontact|Maestro)( contactless)?/, /^eCommerce/, /^BC -/
      parse_from_description
    when /Domicili.ring/, "Uw doorlopende betalingsopdracht"
      @transaction_type = "Domiciliëring"
    when /^Overschrijving/, /^Instantbetaling/, "Storting Banksys", "Terugbetaling transactie debetkaart"
      # Nothing needs to be done
    when /^Beheren vd rek/, /^Kosten/, /Betaling kredietlasten/
      @counterparty = "Crelan"
    when "Opneming Bancontact", "Maestro opneming"
      @counterparty ||= "Cash"
    else
      raise "Unknown transaction type: #{@transaction_type}"
    end
    return self
  end

  def parse_from_description
    re = /^(?<counterparty>.*)?\s*(?<time>\d{2}-\d{2}-\d{4}\s\d{2}:\d{2}) (?<place>.*) 6703.*$/
    captures = re.match(@description)&.named_captures

    @incurred_at = Time.strptime(captures["time"], "%d-%m-%Y %H:%M")
    @counterparty = [captures["counterparty"], captures["place"]].select(&:present?).map(&:strip).join(" ")
  end
end




