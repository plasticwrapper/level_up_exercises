require_relative "dinodex_parser"
require "csv"

class DinoDex
  DINO_FILENAME1 = "dinodex.csv"
  DINO_FILENAME2 = "african_dinosaur_export.csv"

  attr_accessor :dino_data

  def initialize
    @dino_data = parse_dino_files
  end

  def parse_dino_files
    parser = DinoDexParser.new([DINO_FILENAME1, DINO_FILENAME2])
    parser.data
  end

  def grab_all_bipeds
    filter_by_column("WALKING", "Biped")
  end

  def grab_all_carnivores
    filter_by_column("DIET", "Carnivore")
  end

  def grab_all_jurassics
    filter_by_column("PERIOD", "Jurassic")
  end

  def grab_all_big_dinos
    filter_by_weight_greater_than_or_equal_to(2000)
  end

  def grab_all_small_dinos
    filter_by_weight_less_than(2000)
  end

  def grab_dino_by_name(dino_name)
    filter_by_column("NAME", dino_name)
  end

  private

  # Duplicating this CSV table is inefficient and won't scale with larger sets
  # of data.  I'm lazy.
  def duplicate_csv_table(csv_table)
    CSV.parse(csv_table.to_s, headers: true)
  end

  def filter_by_weight_greater_than_or_equal_to(weight)
    filter_by_weight(weight, operator: "greater_equal")
  end

  def filter_by_weight_less_than(weight)
    filter_by_weight(weight, operator: "less_than")
  end

  def filter_by_weight(weight, operator: "less_than")
    duplicate_csv_table(@dino_data).delete_if do |row|
      row_weight = row["WEIGHT_IN_LBS"].to_i
      if operator == "less_than"
        comparison = (row_weight > weight.to_i)
      else
        comparison = (row_weight <= weight.to_i)
      end
      comparison || (row_weight == 0)
    end
  end

  def filter_by_column(column, filter)
    duplicate_csv_table(@dino_data).delete_if do |row|
      row[column] != filter
    end
  end
end
