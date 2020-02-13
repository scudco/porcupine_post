# Porcupine Post

```
bundle
yarn
bundle exec rails db:migrate
bundle exec rails s
```

To run specs ensure a rails server is running and chromedriver is installed:
```
bundle exec rspec
```

If you want to load fixture data in the development database
```
bundle exec rails db:fixtures:load FIXTURES_DIR=../../spec/fixtures # There is a bug in this task
```

**## TODO
  * Add pagination controls and params
  * *Actually style things
  * Separate Author/User
  * Clean up all the `rails new` mess
  * Clean up all the devise install mess
