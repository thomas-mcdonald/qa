# Setup

```
brew install postgresql phantomjs
bundle install
rake db:setup
rake db:seed_fu
```

... or something like that. I'm working on a Vagrant setup that will be much easier.

# Import sample data

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