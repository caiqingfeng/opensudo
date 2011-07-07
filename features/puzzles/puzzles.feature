Feature: Puzzles
  As a visitor to the website
  I want to see puzzles
  so I can play it

 
    Scenario: Create Puzzles
      Given I am a user named "foo" with an email "user@test.com" and password "please"
      When I sign in as "user@test.com/please"
      Then I should be signed in
      When I go to puzzles new
      And I select "Level" with "easy *"
      And I fill in "Name" with "First Puzzle"
      And I fill in "Description" with "First Puzzle"
      And I change the value of the hidden field "puzzle[cellstring]" to "cell11:1,cell99:9"
      And I press "Save"
      Then I should see "Puzzle was successfully created."