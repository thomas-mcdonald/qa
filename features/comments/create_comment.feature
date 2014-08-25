Feature: Create comment
  In order to improve the quality of content on the site and provide clarifictions
  As a user
  I want to be able to create commetns

  @javascript
  Scenario: Create comment on question
  Given I am logged in
  And I can create comments
  And there exists a question
  And I visit the question page
  When I click on add comment
  And I fill out the comment form and submit it
  Then I should see the comment
