Feature: Create vote
  In order to participate in selecting quality answer to questions
  As a user of the site
  I want to be able to interact with the voting system

  Scenario: Users must be logged in to vote
    Given there exists a question
    When I visit the question page
    And I click on the upvote question button
    Then I am told I have to log in

  Scenario: User can upvote
    Given I am logged in
    And there exists a question
    When I visit the question page
    And I click on the upvote question button
    Then I see an active upvote
    And I see an updated vote count

  Scenario: User cannot upvote own post
    Given I am logged in
    And I have asked a question
    When I visit the question page
    And I click on the upvote question button
    Then I do not see an active upvote
    And I am told I cannot vote on my own posts
