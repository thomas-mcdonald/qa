Feature: Tag autocomplete
  In order to use the tags which have already been used on the site
  As a question asker
  I want to be able to see tag suggestions

  Scenario: Existing tags are loaded in and suggested
    Given I am logged in
    And I visit the new question page
    And there exists some tags
    When I type the beginning of a tag
    Then I should see the tag suggested in a dropdown

  Scenario: Adding new tags
    Given I am logged in
    And I visit the new question page
    When I type a new tag
    Then I should see a link to create the new tag
