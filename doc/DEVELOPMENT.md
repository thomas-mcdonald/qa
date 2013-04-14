# Setup

```
brew install postgresql phantomjs
bundle install
rake db:setup
```

... or something like that. I'm working on a Vagrant setup that will be much easier.

# Import sample data

QA will import Stack Exchange data dumps. Drop the un7zed files into lib/import/data and run `rake import:se`.