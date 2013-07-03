Feature: Edit answer
  In order to improve the site for everyone
  As a logged in user
  I want to be able to edit and update answers

  Scenario: Anonymous users cannot edit questions
    Given there exists a question with an answer
    When I visit the question page
    Then I cannot see a link to edit the answer

  Scenario: Logged in users can edit questions
    Given I am logged in
    And there exists a question with an answer
    When I visit the question page
    Then I can see a link to edit the answer
  
  Scenario: Logged in users can update questions
    Given I am logged in
    And there exists a question with an answer
    When I visit the answer edit page
    And I submit the form with updated answer information
    Then I can see the updated answer