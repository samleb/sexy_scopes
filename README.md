SexyScopes
==========

**Write beautiful and expressive ActiveRecord scopes without SQL**

* [Source Code](https://github.com/samleb/sexy_scopes)
* [Rubygem](http://rubygems.org/gems/sexy_scopes)
* [Travis CI](https://travis-ci.org/samleb/sexy_scopes)

SexyScopes is a gem that adds syntactic sugar for creating scopes in ActiveRecord.

**WARNING**: This gem requires Ruby >= 1.9.2 and ActiveRecord >= 3.1

Usage & Examples
----------------

SexyScopes introduces an `attribute` method on ActiveRecord model classes, which returns
objects that represent a given column, and can be used with operators to constructs
meaningful `where` predicates:

```ruby
# price     :integer
# category  :string
# visible   :boolean
# draft     :boolean
class Product < ActiveRecord::Base
  scope :visible, (attribute(:category) != nil) & (attribute(:draft) == false)
  
  def self.cheaper_tran(price)
    where attribute(:price) < price
  end
end
```

For convenience, SexyScopes dynamically resolves methods whose name represent a column,
i.e. `Product.price` is equivalent to `Product.attribute(:price)`.
This allows for really expressive statements:

```ruby
# Select all categories having products with a price < 10
Category.joins(:products).where(Product.price < 10)
```

The above example can therefore be simplified:

```ruby
class Product < ActiveRecord::Base
  scope :visible, (category != nil) & (draft == false)
  
  def self.cheaper_tran(price)
    where self.price < price
  end
  
  # Please note that, as `name` is already an ActiveRecord method we can't use `self.name` here.
  def self.search(term)
    where attribute(:name) =~ "%#{term}%"
  end
end
```

How does it work ?
------------------

SexyScopes is actually a wrapper around [Arel](https://github.com/rails/arel#readme).
The `attribute` method works by returning extended `Arel::Attribute` objects that can
be chained using Ruby operators.

Here is a complete list of operators, and their `Arel::Attribute` equivalents:

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

Advanced Examples
-----------------

```ruby
class User < ActiveRecord::Base
  (score + 20 == 40).to_sql
  # => ("users"."score" + 20) = 40
  
  # Columns can even be coerced when used in additions:
  (20 + score == 40).to_sql
  # => (20 + "users"."score") = 40
  
  ((username == "Bob") | (username != "Alice")).to_sql
  # => ("users"."username" = 'Bob' OR "users"."username" != 'Alice')
end

class Product < ActiveRecord::Base
  predicate = (attribute(:name) == nil) & ~category.in(%w( shoes shirts ))
  predicate.to_sql
  # => "products"."name" IS NULL AND NOT ("products"."category" IN ('shoes', 'shirts'))
  
  # These predicates can be used as arguments to `where`
  where(predicate).all
  # => SELECT "products".* FROM "products" WHERE "products"."name" IS NULL AND 
  #    NOT ("products"."category" IN ('shoes', 'shirts'))
end
```

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

Copyright (c) 2010-2013 Samuel Lebeau. See LICENSE for details.
