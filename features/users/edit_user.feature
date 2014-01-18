Feature: Edit user
  In order to keep my user information up to date
  As a user
  I want to be able to update my user information

  Scenario: Editing your own profile
    Given I am logged in
    When I visit the user edit page
    And I update my name and submit the form
    Then I should be redirected to my profile page
    And I should see my updated name