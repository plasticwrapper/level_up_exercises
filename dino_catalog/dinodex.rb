require_relative "lib/dinodex_presenter"

# 1. parse both csv files
dino = DinoDexPresenter.new

# 2. answer these questions
## display all dinosaurs that were bipeds
dino.display_all_bipeds

## display all dinosaurs that were carnivores, including insects and fish
dino.display_all_carnivores

## display dinosaurs for specific periods
dino.display_all_jurassics

## display only big dinosaurs (> 2 tons)
dino.display_all_big_dinos

## display only small dinosaurs (< 2 tons)
dino.display_all_small_dinos

# 3. display all the facts for a given dino
dino.display_all_facts_about "Albertosaurus"

# 4. display all the dinosaurs in a given collection
dino.display_dinos dino.dinodex.grab_all_small_dinos
