Feature: Edit question
  In order to keep the site content updated
  As a registered user
  I want to be able to edit questions

  Scenario: User without permissions cannot view links to edit questions
    Given I am logged in and cannot edit questions
    And there exists a question
    When I visit the question page
    Then I cannot see a link to edit the question

  Scenario: User with permissions can view edit question links
    Given I am logged in and can edit questions
    And there exists a question
    When I visit the question page
    Then I can see a link to edit the question

  Scenario: User with permissions can edit successfully
    Given I am logged in and can edit questions
    And there exists a question
    When I visit the question edit page
    And I edit and submit the question data
    Then I am on the question page
    And I should see the updated question