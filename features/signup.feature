Feature: Signup
  In order to associate my actions with myself
  As a user
  I want to be able to sign up for the application

  Scenario: Selecting a login provider
    When I visit the signup page
    And I click on the Google provider
    Then I should be returned to the confirmation page
    And I should see a form for user details filled in

  Scenario: Confirming user details
    When I visit the signup page
    And I click on the Google provider
    And I submit the user details form
    Then I should have a user created with those details
    And I should be logged in