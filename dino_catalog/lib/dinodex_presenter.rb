class DinoDexPresenter
  attr_accessor :dinodex

  def initialize
    @dinodex = DinoDex.new
  end

  def display_all_bipeds
    display_header "All Bipeds"
    display_names dinodex.grab_all_bipeds
  end

  def display_all_carnivores
    display_header "All Carnivores"
    display_names dinodex.grab_all_carnivores
  end

  def display_all_jurassics
    display_header "All Jurassics"
    display_names dinodex.grab_all_jurassics
  end

  def display_all_big_dinos
    display_header "All Big Dino's"
    display_names dinodex.grab_all_big_dinos
  end

  def display_all_small_dinos
    display_header "All Small Dino's"
    display_names dinodex.grab_all_small_dinos
  end

  def display_all_facts_about(dino_name)
    display_header "All About #{dino_name}"
    display_dino dinodex.grab_dino_by_name(dino_name)
  end

  def display_dino(csv_table)
    csv_table.each do |row|
      row.each do |header, field|
        if field
          display header + ": " + field
        end
      end
      display_line_break
    end
  end

  def display_dinos(dino_list)
    display_header "List of Dino's!"
    display_dino dino_list
  end

  private

  def display(message)
    puts message
  end

  def display_header(message)
    display_line_break
    display message
    display_line_break
  end

  def display_column(csv_table, column)
    csv_table.each do |row|
      display row[column]
    end
  end

  def display_names(csv_table)
    display_column(csv_table, "NAME")
  end

  def display_line_break
    display "--------------------------------------"
  end
end

