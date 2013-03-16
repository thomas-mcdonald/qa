Feature: Create vote
  In order to participate in selecting quality answer to questions
  As a user of the site
  I want to be able to interact with the voting system

  @javascript
  Scenario: Users must be logged in to vote
    Given I am not logged in
    And I have a question
    And I am on the question page
    When I click on the upvote question button
    Then I am told I have to log in

  @javascript
  Scenario: User can upvote
    Given I am logged in
    And I have a question
    And I am on the question page
    When I click on the upvote question button
    Then I should see an active upvote
    And I should see an updated vote count