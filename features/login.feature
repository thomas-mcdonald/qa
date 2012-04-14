Feature: Login
  In order to associate actions with myself and to access additional features
  As a user
  I want to be able to log in to the application

  @omniauth
  Scenario: Logging in
    Given I am on the login page
    And I have already signed up
    When I click on the Google provider
    Then I should be returned to the homepage
    And I should be logged in