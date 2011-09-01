Feature: Manage questions
  In order to use the site
  As a user
  I want to be able to add questions
  
  Scenario: Register new question
    Given I am on the new question page
    And I press "Create Question"

  Scenario: Delete question
    Given the following questions:
      ||
      ||
      ||
      ||
      ||
    When I delete the 3rd question
    Then I should see the following questions:
      ||
      ||
      ||
      ||
