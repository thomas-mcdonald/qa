Feature: Index page
  In order to be able to find interesting questions by different views
  As a user
  I want to be able to load and interact with the homepage

  Scenario: Can view the index page
    Given I am logged in
    And there exists several questions
    When I visit the new index page
    Then I should see those questions
