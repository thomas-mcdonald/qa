# TODO!

This has been (mostly) deprecated in favour of using Pivotal Tracker to manage plans for new releases

## Global
* Rate limiting

## Administration
* Admin stats page - counts of answer/questions/users/percentage of answered/percentage of asked

## Posts (both question & answers)

* Clicking on a vote score should display the up/down split
* Site configuration of an array of 'banned URLs' (e.g URL shorteners) which
  will cause a validation error.
* Search

## Questions

* Limit the length of titles used for the slug
* Add sorting options for questions
* Use HyperLogLog for storing view counts

## Answers

* If you have already answered a question the insert form is hidden and you are
  asked if you actually want to create another answer or edit existing.
* Errors in answers should be handled.
* Answers below a given score should be greyed out
* Add pagination and sorting for answers

## Comments

* ...
* pretty self explanatory

## Users

* add more authentication methods - username/password & social login

## Tags

* The 'questions tagged' view should allow scoping of questions by more than
  one tag.

## Import
### Stack Exchange

* Accepting answers does not create the reputation events

### Shapado

* Support


## Misc

* Add some sort of rubocop (sp?) to the project
* The DB seed should include a 'changelog' (and this should be maintained
  in CHANGELOG.md).
