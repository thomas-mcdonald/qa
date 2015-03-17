Feature: Accept answer
  In order to easily find the correct answer
  As a user
  I want to be able to accept an answer and view the accepted answer

  Scenario: Question viewers can see the accepted answer
    Given there exists a question with an accepted answer
    When I visit the question page
    Then I see an indication of the accepted answer

  Scenario: Accepting an answer
    Given I am logged in
    And I asked a question with an answer
    When I visit the question page
    And I click on the accept answer button
    Then I should see it become active

  Scenario: Unaccepting an answer
    Given I am logged in
    And I asked a question with an accepted answer
    When I visit the question page
    And I click on the unaccept answer button
    Then I should see it become inactive
