Feature: Create question
  In order to be able to effectively use the site
  As a user
  I want to be able to create questions and view them

  Scenario: Not allowed to create question when not logged in
    Given I am on the homepage
    When I click on the Ask Questions button
    Then I should be redirected to the homepage
  
  
  
