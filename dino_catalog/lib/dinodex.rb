require "csv"

class DinoDex
  DINO_FILENAME1 = "dinodex.csv"
  DINO_FILENAME2 = "african_dinosaur_export.csv"

  attr_accessor :dino_data

  def initialize
    @dino_data = parse_dino_files
  end

  def parse_dino_files
    dino_data1 = CSV.read(DINO_FILENAME1, headers: true)
    dino_data2 = CSV.read(DINO_FILENAME2, headers: true)

    prune_period_values(merge_data(dino_data1, dino_data2))
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

  # This data transformation is brittle, be careful.
  def merge_data(csv_table1, csv_table2)
    csv_table2.each do |row|
      csv_table1 << [
        row["Genus"],                         # NAME
        row["Period"],                        # PERIOD
        "Africa",                             # CONTINENT
        convert_carnivore(row["Carnivore"]),  # DIET
        row["Weight"],                        # WEIGHT_IN_LBS
        row["Walking"],                       # WALKING
        nil                                   # DESCRIPTION
      ]
    end

    csv_table1
  end

  def prune_period_values(csv_table)
    csv_table.each do |row|
      row["PERIOD"].gsub!("Late ", "")
      row["PERIOD"].gsub!("Early ", "")
    end

    csv_table
  end

  def convert_carnivore(carnivore_bool)
    return "Carnivore" if carnivore_bool == "Yes"
    "Herbivore"
  end
end
