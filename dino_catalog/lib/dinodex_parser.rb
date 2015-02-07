require 'csv'

class DinoDexParser
  attr_accessor :data

  def initialize(files)
    file_data = []

    files.each_with_index do |filename, index|
      file_data[index] = CSV.read(filename, headers: true)
    end

    @data = file_data.shift

    merge_data(file_data)

    cleanup_values
  end

  def merge_data(file_data)
    file_data.each do |file|
      file.each do |row|
        @data << transform_row(row)
      end
    end
  end

  # This data transformation is brittle.  Be careful.
  def transform_row(row)
    [
      row["Genus"],                         # NAME
      row["Period"],                        # PERIOD
      "Africa",                             # CONTINENT
      row["Carnivore"],                     # DIET
      row["Weight"],                        # WEIGHT_IN_LBS
      row["Walking"],                       # WALKING
      nil                                   # DESCRIPTION
    ]
  end

  def cleanup_values
    prune_period_values
    convert_carnivore_values
  end

  def prune_period_values
    @data.each do |row|
      row["PERIOD"].gsub!("Late ", "")
      row["PERIOD"].gsub!("Early ", "")
    end
  end

  def convert_carnivore_values
    @data.each do |row|
      row["DIET"] = "Carnivore" if row["DIET"] == "Yes"
      row["DIET"] = "Herbivore" if row["DIET"] == "No"
    end
  end
end
