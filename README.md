# QA

[![Build Status](https://semaphoreci.com/api/v1/projects/44e6f8cb-334f-44ef-80eb-a15e915a383a/255594/badge.svg)](https://semaphoreci.com/thomas-mcdonald/qa)


[![Code Climate](https://codeclimate.com/github/thomas-mcdonald/qa.png)](https://codeclimate.com/github/thomas-mcdonald/qa) [![Coverage Status](https://coveralls.io/repos/thomas-mcdonald/qa/badge.png?branch=master)](https://coveralls.io/r/thomas-mcdonald/qa)

**QA is the best way to get your own instance of an internal question and answer site.**

## Installation

1. Ensure you have both PostgreSQL 9.3+ and Redis 2.8.9+ installed
2. Install Ruby 2.2.x
3. `git clone git://github.com/thomas-mcdonald/qa.git && cd qa`
4. `bundle install`
5. Check settings in `config/database.yml` and `config/redis.yml`
6. Copy `.env.sample` to `.env` and fill in environment settings as required
7. `bundle exec rake db:create db:schema:load`

### Seed Data

There are a couple of options for seed data:

* `bundle exec rake db:seed:development` will give you a few example questions
* You can import a Stack Exchange data dump for development purposes. Download a dump from [here](https://archive.org/download/stackexchange) and extract to lib/import/data. `rake import:se` will import this data.

*The SE import process is memory-intensive and will take some time - even for smaller Stack Exchange sites. The importer queues a significant number of background jobs which will take time to process - so initial performance may be slower.*

### Running the application

The application processes are defined in the Procfile, which can be managed by [Foreman](https://ddollar.github.io/foreman/).

Install it with `gem install foreman`, and start the application and job queues with `foreman start`.

## Stack

* Rails 4.2
* Postgres
* Redis
