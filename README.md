SexyScopes
==========

**Write beautiful and expressive ActiveRecord scopes without SQL**

* [Source Code](https://github.com/samleb/sexy_scopes)
* [Rubygem](http://rubygems.org/gems/sexy_scopes)

sexy_scope is a small wrapper around `Arel::Attribute` that adds a little syntactic
sugar when creating scopes in ActiveRecord 3.

It adds an `attribute` class method which takes an attribute name and returns an 
`Arel::Attribute` wrapper, which responds to common operators to return predicates
objects that can be used as arguments to `ActiveRecord::Base.where`.


Usage & Examples
----------------

```ruby
class Product < ActiveRecord::Base
  scope :untitled, where(attribute(:name) == nil)
  
  def self.cheaper_than(price)
    where attribute(:price) < price
  end
  
  def self.search(term)
    where attribute(:name) =~ "%#{term}%"
  end
end
```

Classic `Arel::Attribute` methods (`lt`, `in`, `matches`, `not`, etc.) are still 
available and predicates can be chained using special operators `&` (`and`),
`|` (`or`), and `~` (`not`):

```ruby
class Product
  (attribute(:age) + 20 == 40).to_sql
  # => ("users"."age" + 20) = 40
  
  ((attribute(:username) == "Bob") | (attribute(:username) != "Alice")).to_sql
  # => ("users"."username" = 'Bob' OR "users"."username" != 'Alice')
  
  predicate = (attribute(:name) == nil) & ~attribute(:category).in(%w( shoes shirts ))
  predicate.to_sql
  # => "products"."name" IS NULL AND NOT ("products"."category" IN ('shoes', 'shirts'))
  
  # These predicates can be used as arguments to `where`
  where(predicate).all
  # Rails SQL Logger: SELECT "products".* FROM "products" WHERE "products"."name" IS NULL
  #                   AND NOT ("products"."category" IN ('shoes', 'shirts'))
end
```

Here is a complete list of Arel method aliases:

* For predicates:
  - `==`: `eq`
  - `=~`: `matches`
  - `!~`: `does_not_match`
  - `>=`: `gteq`
  - `>` : `gt`
  - `<` : `lt`
  - `<=`: `lteq`
  - `!=`: `not_eq`

* For combination
  - `&`: `and`
  - `|`: `or`
  - `~`: `not` (unfortunately, unary prefix `!` doesn't work with ActiveRecord)


Installation
------------

Add this line to your application's Gemfile:

    gem 'sexy_scopes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sexy_scopes

Then require it in your application code:

    require 'sexy_scopes'


Contributing
------------

Report bugs or suggest features using [GitHub issues](https://github.com/samleb/sexy_scopes).

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


Copyright
---------

Copyright (c) 2010-2012 Samuel Lebeau. See LICENSE for details.
