Feature: Signup
  In order to associate my actions with myself
  As a user
  I want to be able to sign up for the application

  Scenario: Viewing login providers
    Given I am on the signup page
    Then I should see a series of links to login providers
    And I should see a title of "Signup"

  Scenario: Selecting a login provider
    Given I am on the signup page
    When I click on the Google provider
    Then I should be on the Google authentication page