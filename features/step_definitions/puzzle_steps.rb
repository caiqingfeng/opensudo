"puzzle 1" "1" "puzzle 1" "cell11:1,cell99:8"
Given /^A puzzle named "([^"]*)" with level "([^"]*)" and description "([^"]*)" and cellstring "([^"]*)"$/ do |name, level, description, cellstring|
  Puzzle.new(:name => name,
            :level => level,
            :description => description,
            :cellstring => cellstring).save!
end

