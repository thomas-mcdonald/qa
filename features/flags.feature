@javascript
Feature: Flags
  In order to help manage the site
  As a user
  I want to be able to create flags
  
  Scenario: View a list of flag reasons
    Given I am logged in
    And a question exists
    And I go to the question's page
    When I follow "flag"
    Then I should see a modal window

