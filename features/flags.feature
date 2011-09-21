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

  Scenario: Only tag a question once
    Given I am logged in
    And I have a flag on a question
    And I go to the question's page
    When I follow "flag"
    Then I should see a modal with the title "Whoops"

