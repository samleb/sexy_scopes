# Changelog
All notable changes to this project will be documented in this file.

## 1.0.0.beta1 - 2017-09-17

### Added
- Support for ActiveRecord 5
- Support for Ruby >= 2.2
- Support for Rubinius 3
- Alternative `where` syntax not implemented using `instance_exec` (relation is passed when block takes an argument)
- Support for block syntax with `where.not`

### Removed
- Support for ActiveRecord < 4.2
- Support for Ruby 1.9.3

## 0.8.0 - 2015-01-18

### Added
- Support for ActiveRecord 4.2 (thanks to Thomas Kriechbaumer)
- Support for blocks in `where`

### Fixed
- Arel no longer needs to be required before SexyScopes

## 0.7.0 - 2014-07-23

### Fixed
- Existing class methods no longer overriden by dynamic method generation

### Added
- Support for Regular Expressions with the `=~` and `!~` operators (PostgreSQL, MySQL & SQLite3)
- Support for ActiveRecord 4.1
- Support for Arel 6
- Typecasting of predicates values to target columns' types
- Integration with [Travis CI](https://travis-ci.org/samleb/sexy_scopes)

### Removed
- Support for Ruby 1.9.2

## 0.6.0 - 2013-05-29

### Added
- Support for JRuby and Rubinius

### Removed
- Support for Ruby < 1.9.2 and ActiveRecord < 3.1
