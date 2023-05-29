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
      initiated_at: @initiated_at,
      transaction_type: @transaction_type,
      other: @other,
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
    @description = @row["Mededeling"]
    @other = @row["Tegenpartij"]

    case @transaction_type
    when "Betaling Bancontact contactless", "Betaling Maestro contactless", "eCommerce Mobile"
      parse_from_description
    when "Domicili?ring"
      @transaction_type = "Domiciliëring"
      @other = @row["Tegenpartij"] + " " + @row["Rekening tegenpartij"]
    when "Overschrijving via Crelan Mobile", "Domicili?ring", "Overschrijving in uw voordeel"
      @other = @row["Tegenpartij"] + " " + @row["Rekening tegenpartij"]
    when "Beheren vd rek Economy Plus Pack"
      @other = "Crelan"
    else
      raise "Unknown transaction type: #{@transaction_type}"
    end
    return self
  end

  def parse_from_description
    re = /^(?<other>.*)\s(?<time>\d{2}-\d{2}-\d{4}\s\d{2}:\d{2}) (?<place>.*) 6703.*$/
    captures = re.match(@description).named_captures
    @initiated_at = Time.strptime(captures["time"], "%d-%m-%Y %H:%M")
    @other = captures["other"] + " " + captures["place"]
  end
end




