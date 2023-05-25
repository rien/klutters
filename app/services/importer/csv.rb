# frozen_string_literal: true

class Importer::Csv
  def initialize(file)
    @file = file
  end

  def import
    CSV.foreach(@file.path, headers: true) do |row|

    end
  end
end
