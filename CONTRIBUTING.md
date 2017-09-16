Contributing
------------

### Setup a development environment

- Create the database config file from the sample:

      cp spec/config.example.yml spec/config.yml

- Install the required gems:

      bundle install
      bundle exec appraisal install

- Edit `spec/config.yml` to reflect the configuration of all your database adapters (similar to `database.yml`)

- To run the test suite, do:

      bundle exec rake spec

- By default, this will only run the tests with the latest version of ActiveRecord and using an in-memory SQLite3 database.
  This is the simplest way to ensure you've not broken anything.

- If you want to run the test suite using a particular database, do:

      bundle exec rake spec:mysql
      bundle exec rake spec:postgresql

- Before committing your changes, ensure they're compatible with all adapters, *and* all ActiveRecord versions by running:

      bundle exec appraisal rake spec:all

### Working with GitHub

Report bugs or suggest features using [GitHub issues](https://github.com/samleb/sexy_scopes).

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

TODO
----

- Document the `sql_literal` method and how it can be used to create complex subqueries
- Handle associations (i.e. `Post.comments == Comment.joins(:posts)` ?)
