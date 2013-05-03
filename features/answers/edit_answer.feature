Feature: Editing answers
  In order to improve the site for everyone
  As a logged in user
  I want to be able to edit and update answers

  Scenario: Anonymous users cannot edit questions
    Given I am not logged in
    And I have a question with an answer
    When I am on the question page
    Then I cannot see a link to edit the answer

  Scenario: Logged in users can edit questions
    Given I am logged in
    And I have a question with an answer
    When I am on the question page
    Then I can see a link to edit the answer
  
  Scenario: Logged in users can update questions
    Given I am logged in
    And I have a question with an answer
    And I am on the answer edit page
    When I fill out the form with updated answer information
    And I click on the submit button
    Then I am on the question page
    And I can see the updated answer