# Porcupine Post

```
bundle
bundle exec rails s
```

To run tests ensure chromedriver is installed and
```
bundle exec rspec
```

If you want to load fixture data:
```
bundle exec rails db:fixtures:load FIXTURE_PATH='../../spec/fixtures' # There is a bug in this task
```

**## TODO
  * Add pagination controls and params
  * *Actually style things
  * Separate Author/User
  * Clean up all the `rails new` mess
  * Clean up all the devise install mess
