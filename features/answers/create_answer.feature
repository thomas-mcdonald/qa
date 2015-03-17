Feature: Create answer
  In order to use the site effectively
  As a user
  I want to be able to create answers

  Scenario: Create answer as logged in user
    Given I am logged in
    And there exists a question
    And I visit the question page
    When I submit the answer form with a valid answer
    Then I should see the answer
