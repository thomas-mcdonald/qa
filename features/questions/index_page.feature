Feature: Index page
  In order to be able to find interesting questions by different views
  As a user
  I want to be able to load and interact with the homepage

  Scenario: Can view the index page
    Given I am logged in
    And there exists several questions
    When I visit the index page
    Then I should see those questions

  Scenario: Clicking on the votes tab loads ordered questions
    Given I am logged in
    And there exists several questions
    And those questions have been voted on
    When I visit the index page
    And I click on the votes tab
    Then I should see those questions
    And they should be in vote sorted order
