Feature: Admin users
  In order to effectively administrate the site
  As an administrator
  I want to be able edit user data

  Background:
    Given I am logged in as an admin

  Scenario: Add admin flag
    Given there exists another user
    When I visit a user admin edit page
    And I submit the form with the admin flag checked
    Then I should be redirected to the users page
    And I should see that they are an admin
