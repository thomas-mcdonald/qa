Feature: Signup
  In order to associate my actions with myself
  As a user
  I want to be able to sign up for the application

  Scenario: Viewing signup providers
    Given I am on the signup page
    Then I should see a series of links to login providers
    And I should see a title of "Signup"

  Scenario: Selecting a login provider
    Given I am on the signup page
    When I click on the Google provider
    Then I should be returned to the confirmation page
    And I should see a form for user details filled in

  Scenario: Confirming user details
    Given I am on the signup page
    And I click on the Google provider
    When I click on the submit button
    Then I should have a user created with those details