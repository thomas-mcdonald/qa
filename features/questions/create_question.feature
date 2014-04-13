Feature: Create question
  In order to be able to effectively use the site
  As a user
  I want to be able to create questions and view them

  Scenario: Can create question when logged in
    Given I am logged in
    When I visit the new question page
    And I submit the form with a valid question
    Then I should see the question

  Scenario: Cannot create question without tag data
    Given I am logged in
    When I visit the new question page
    And I submit the form with question data but without any tags
    Then I am on the new question page
    And I should see that there is an error with the tags
