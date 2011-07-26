Feature: Manipulating Puzzles
  As a manager to the website
  I want to manage puzzles (create/list/update/delete)
 
    Scenario: Create Puzzles
      Given I am a user named "foo" with an email "user@test.com" and password "please"
      When I sign in as "user@test.com/please"
      Then I should be signed in
      When I go to puzzles new
      And I select "easy *" from "Level"
      And I fill in "Name" with "First Puzzle"
      And I fill in "Description" with "First Puzzle"
      And I change the value of the hidden field "puzzle[cellstring]" to "cell11:1,cell99:9"
      And I press "Save"
      Then I should see "Puzzle was successfully created."

    Scenario: List Puzzles
      Given I am a user named "foo" with an email "user@test.com" and password "please"
      Given A puzzle named "puzzle 1" with level "1" and description "puzzle 1" and cellstring "cell11:1,cell99:8"
      When I sign in as "user@test.com/please"
      Then I should be signed in
      When I go to puzzles
      Then I should see "puzzle 1"
      
    Scenario: Edit Puzzle
      Given I am a user named "foo" with an email "user@test.com" and password "please"
      Given A puzzle named "puzzle 1" with level "1" and description "puzzle 1" and cellstring "cell11:1,cell99:8"
      When I sign in as "user@test.com/please"
      Then I should be signed in
      When I go to puzzles
      When I follow "Edit"
      And I select "easy *" from "Level"
      And I fill in "Name" with "First Puzzle"
      And I fill in "Description" with "First Puzzle"
      And I change the value of the hidden field "puzzle[cellstring]" to "cell11:1,cell99:8"
      And I press "Save"
      Then I should see "Puzzle was successfully updated."

    Scenario: Delete Puzzle
      Given I am a user named "foo" with an email "user@test.com" and password "please"
      Given A puzzle named "puzzle 1" with level "1" and description "puzzle 1" and cellstring "cell11:1,cell99:8"
      When I sign in as "user@test.com/please"
      Then I should be signed in
      When I go to puzzles
      When I follow "Delete"
      Then I should see "Listing puzzles"

      
      