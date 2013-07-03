Feature: Login
  In order to associate actions with myself and to access additional features
  As a user
  I want to be able to log in to the application

  Scenario: Logging in
    Given I have already signed up
    When I visit the login page
    And I click on the Google provider
    Then I should be returned to the homepage
    And I should be logged in

  @javascript
  Scenario: Logging out
    Given I am logged in
    When I click on the logout button
    Then I should be logged out