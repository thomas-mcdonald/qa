Feature: Edit question
  In order to keep the site content updated
  As a registered user
  I want to be able to edit questions

  Scenario: Logged in user can edit question
    Given I am logged in
    And there exists a question
    When I visit the question page
    Then I can see a link to edit the question

  Scenario: Editing is successful 
    Given I am logged in
    And there exists a question
    When I visit the question edit page
    And I edit and submit the question data
    Then I am on the question page
    And I should see the updated question