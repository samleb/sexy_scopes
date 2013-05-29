SexyScopes
==========

**Write beautiful and expressive ActiveRecord scopes without SQL**

SexyScopes is a gem that adds syntactic sugar for creating ActiveRecord scopes
in Ruby instead of SQL.
This allows for more expressive, less error-prone and database independent conditions.

**WARNING**: This gem requires Ruby >= 1.9.2 and ActiveRecord >= 3.1.

* [Source Code](https://github.com/samleb/sexy_scopes)
* [Rubygem](http://rubygems.org/gems/sexy_scopes)
* [API Documentation](http://rubydoc.info/gems/sexy_scopes)

Usage & Examples
----------------

Let's define a `Product` model with this schema:

```ruby
# price     :integer
# category  :string
# visible   :boolean
# draft     :boolean
class Product < ActiveRecord::Base
end
```

Now take a look at the following scope:

```ruby
scope :visible, where("category IS NOT NULL AND draft = ? AND price > 0", false)
```

Hum, lots of *SQL*, not very *Ruby*-esque...

**With SexyScopes**

```ruby
scope :visible, where((category != nil) & (draft == false) & (price > 0))
```

Much better! Looks like magic? *It's not*.

`category`, `draft` and `price` in this context are methods representing your model's columns.
They respond to Ruby operators (like `<`, `==`, etc.) and can be combined
with logical operators (`&` and `|`) to express complex predicates.

--------------------------

Let's take a look at another example with these relations:

```ruby
# rating:  integer
class Post < ActiveRecord::Base
  has_many :comments
end

# post_id_:  integer
# rating:   integer
class Comment < ActiveRecord::Base
  belongs_to :post
end
```

Now let's find posts having comments with a rating > 3.

**Without SexyScopes**

```ruby
Post.joins(:comments).merge Comment.where("rating > ?", 3)
# ActiveRecord::StatementInvalid: ambiguous column name: rating
```

Because both `Post` and `Comment` have a `rating` column, you have to give the table name explicitly:

```ruby
Post.joins(:comments).merge Comment.where("comments.rating > ?", 3)
```

Not very DRY, isn't it ?

**With SexyScopes**

```ruby
Post.joins(:comments).where Comment.rating > 3
```

Here you have it, clear as day.

How does it work ?
------------------

SexyScopes is essentially a wrapper around [Arel](https://github.com/rails/arel#readme) attribute nodes.

It introduces a `ActiveRecord::Base.attribute(name)` class method returning an `Arel::Attribute` object, which
represent a table column with the given name, that is extended to support Ruby operators.

For convenience, SexyScopes dynamically resolves methods whose name is an existing table column: i.e.
`Product.price` is actually a shortcut for `Product.attribute(:price)`.

Please note that this mechanism won't override any of the existing `ActiveRecord::Base` class methods,
so if you have a column named `name` for instance, you'll have to use `Product.attribute(:name)` instead of
`Product.name` (which is the class actual name, i.e. `"Product"`).

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
# radius:  integer
class Circle < ActiveRecord::Base
  # Attributes can be coerced in arithmetic operations
  def self.perimeter
    2 * Math::PI * radius
  end
  
  def self.area
    Math::PI * radius * radius
  end
end

Circle.where Circle.perimeter > 42
Circle.where Circle.area < 42

class Product < ActiveRecord::Base
  predicate = (attribute(:name) == nil) & ~category.in(%w( shoes shirts ))
  predicate.to_sql
  # => `products`.`name` IS NULL AND NOT (`products`.`category` IN ('shoes', 'shirts'))
  
  where(predicate).all
  # => SELECT `products`.* FROM `products` WHERE `products`.`name` IS NULL AND 
  #    NOT (`products`.`category` IN ('shoes', 'shirts'))
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

TODO
----

- Document the `sql_literal` method and how it can be used to create complex subqueries
- Handle associations (i.e. `Post.comments == Comment.joins(:posts)` ?)

Code Status
-----------

[![Build Status](https://api.travis-ci.org/samleb/sexy_scopes.png)](https://travis-ci.org/samleb/sexy_scopes)
[![Dependencies](https://gemnasium.com/samleb/sexy_scopes.png?travis)](https://gemnasium.com/samleb/sexy_scopes)

Copyright
---------

SexyScopes is released under the [MIT License](http://www.opensource.org/licenses/MIT).

Copyright (c) 2010-2013 Samuel Lebeau, See LICENSE for details.
