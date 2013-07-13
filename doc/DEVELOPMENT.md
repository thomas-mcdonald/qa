# Development Setup

## Prerequisites

QA requires Ruby 2.0.0+ and PostgreSQL to be installed. Running the test suite also requires
phantomjs. If you're on OS X and use homebrew, PostgreSQL and phantomjs can be installed with
`brew install postgresql phantomjs`

## Setup

0. Make sure you have the prerequisites above installed
1. Clone the repository - `git clone git://github.com/thomas-mcdonald/qa.git`
2. Setup the database - `rake db:setup`
3. Install some seed data - `rake db:seed_fu`
4. Start the webserver and background processing - `bundle exec foreman start`

## Import sample data

QA will import Stack Exchange data dumps. Drop the un7zed files into
`lib/import/data` and run `rake import:se`.

## Login

By default you won't be able to log in with the seed data or a SE import due to
not having any OpenID related keys.

Hit `/dev/login?as=#{id}` to login as a specific user.


# Testing

We use RSpec and Spinach to run tests. You can run all tests, and iteratively
run them during development by calling `bundle exec guard`.

Our Spinach tests are heavily inspired by the layout and setup of
[gitlab's features][gitlabf].

[gitlabf]: https://github.com/gitlabhq/gitlabhq/tree/master/features