SexyScopes
==========

[![Gem Version](http://img.shields.io/gem/v/sexy_scopes.svg?style=flat)](https://rubygems.org/gems/sexy_scopes)
[![Dependencies](https://img.shields.io/gemnasium/samleb/sexy_scopes.svg?style=flat)](https://gemnasium.com/samleb/sexy_scopes)
[![Code Climate](https://img.shields.io/codeclimate/github/samleb/sexy_scopes.svg?style=flat)](https://codeclimate.com/github/samleb/sexy_scopes)
[![Build Status](https://img.shields.io/travis/samleb/sexy_scopes.svg?style=flat)](https://travis-ci.org/samleb/sexy_scopes)
[![Coverage Status](https://img.shields.io/coveralls/samleb/sexy_scopes.svg?style=flat)](https://coveralls.io/r/samleb/sexy_scopes)

**Write beautiful and expressive ActiveRecord scopes without SQL**

SexyScopes is a gem that adds syntactic sugar for creating ActiveRecord scopes
in Ruby instead of SQL.
This allows for more expressive, less error-prone and database independent conditions.

**WARNING**: This gem requires Ruby >= 2.0.0 and ActiveRecord >= 4.2

* [Source Code](https://github.com/samleb/sexy_scopes)
* [Rubygem](http://rubygems.org/gems/sexy_scopes)
* [API Documentation](http://rubydoc.info/gems/sexy_scopes)

Usage & Examples
----------------

Let's define a `Product` model with this schema:

```ruby
# price     :integer
# category  :string
# draft     :boolean
class Product < ActiveRecord::Base
end
```

Now take a look at the following scope:

```ruby
scope :visible, -> { where('category IS NOT NULL AND draft = ? AND price > 0', false) }
```

Hum, lots of *SQL*, not very *Ruby*-esque...

**With SexyScopes**

```ruby
scope :visible, -> { where((category != nil) & (draft == false) & (price > 0)) }
```

Much better! Looks like magic? *It's not*.

`category`, `draft` and `price` in this context are methods representing your model's columns.
They respond to Ruby operators (like `<`, `==`, etc.) and can be combined
with logical operators (`&` and `|`) to express complex predicates.

--------------------------

Let's take a look at another example with these relations:

```ruby
# rating:  integer
# body: text
class Post < ActiveRecord::Base
  has_many :comments
end

# post_id:  integer
# rating:   integer
# body: text
class Comment < ActiveRecord::Base
  belongs_to :post
end
```

Now let's find posts having comments with a rating greater than a given rating in a controller action:

**Without SexyScopes**

```ruby
@posts = Post.joins(:comments).where('rating > ?', params[:rating])
```

This expression, while syntactically valid, raises the following exception:

```
ActiveRecord::StatementInvalid: ambiguous column name: rating
```

Because both `Post` and `Comment` have a `rating` column, you have to give the table name explicitly:

```ruby
@posts = Post.joins(:comments).where('comments.rating > ?', params[:rating])
```

**With SexyScopes**

Since `Comment.rating` represents the `rating` column of the `Comment` model, the above can be rewritten as such:

```ruby
@posts = Post.joins(:comments).where { rating > params[:rating] }
```

Here you have it, clear as day, still protected from SQL injection.

Installation
------------

Add this line to your application's Gemfile:

    gem 'sexy_scopes'

And then execute:

    bundle

Or install it yourself as:

    gem install sexy_scopes

Then require it in your application code:

    require 'sexy_scopes'

How does it work ?
------------------

SexyScopes is essentially a wrapper around [Arel](https://github.com/rails/arel#readme) attribute nodes.

It introduces a `ActiveRecord::Base.attribute(name)` class method returning an `Arel::Attribute` object, which
represent a table column with the given name, that is extended to support Ruby operators.

For convenience, SexyScopes dynamically resolves methods whose name is an existing table column: i.e.
`Product.price` is a shortcut for `Product.attribute(:price)`.

Please note that this mechanism won't override any of the existing `ActiveRecord::Base` class methods,
so if you have a column named `name` for instance, you'll have to use `Product.attribute(:name)` instead of
`Product.name` (which would be in this case the class actual name, `"Product"`).

Here is a complete list of operators, and their `Arel::Attribute` equivalents:

* Predicates:
  - `==`: `eq`
  - `=~`: `matches`
  - `!~`: `does_not_match`
  - `>=`: `gteq`
  - `>` : `gt`
  - `<` : `lt`
  - `<=`: `lteq`
  - `!=`: `not_eq`

* Logical operators:
  - `&`: `and`
  - `|`: `or`
  - `~`: `not`

Block syntax
------------

SexyScopes introduces a new block syntax for the `where` clause, which can be used in 2 different forms:

* With no argument, the block is evaluated in the context of the relation

```ruby
# `price` is `Product.price`
Product.where { price < 500 }

# `body` is `post.comments.body`
post.comments.where { body =~ "%ruby%" }
```

* With an argument, block is called with the relation as argument

```ruby
# `p` is the `Product` relation
Product.where { |p| p.price < 500 }

# `c` is the `post.comments` relation
post.comments.where { |c| c.body =~ "%ruby%" }
```

These 2 forms are functionally equivalent.
The former, while being more concise, is internally implemented using `instance_eval`, which will prevent you from calling method on the receiver (`self`).

*Tip*: Try switching to the later form if you encounter `NoMethodError` exceptions.

Note that you can also use this syntax with `where.not`:

```ruby
Product.where.not { price > 200 }
```

Regular Expressions
-------------------

Did you know that most RDBMS come with pretty good support for regular expressions?

One reason they're quite unpopular in Rails applications is that their syntax is really different amongst
databases implementations.
Let's say you're using SQLite3 in development, and PostgreSQL in testing/production, well that's quite a good reason
not to use database-specific code, isn't it?

Once again, SexyScopes comes to the rescue:
The `=~` and `!~` operators when called with a regular expression will generate the SQL you don't want to know about.

```ruby
predicate = User.username =~ /^john\b(.*\b)?doe$/i

# In development, using SQLite3:
predicate.to_sql
# => "users"."username" REGEXP '^john\b(.*\b)?doe$'

# In testing/production, using PostgreSQL
predicate.to_sql
# => "users"."username" ~* '^john\b(.*\b)?doe$'
```

Now let's suppose that you want to give your admin a powerful regexp based search upon usernames, here's how
you could do it:

```ruby
class Admin::UsersController
  def index
    query = Regexp.compile(params[:query])
    @users = User.where { username =~ query }
    respond_with @users
  end
end
```

Let's see what happens in our production logs (SQL included) when they try this new feature:

```
Started GET "/admin/users?query=bob%7Calice" for xx.xx.xx.xx at 2014-03-31 16:00:50 +0200
  Processing by Admin::UsersController#index as HTML
  Parameters: {"query"=>"bob|alice"}
  User Load (0.1ms)  SELECT "users".* FROM "users"  WHERE ("users"."username" ~ 'bob|alice')
```

The proper SQL is generated, protected from SQL injection BTW, and from now on you have reusable code for
both you development and your production environment.

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

Circle.where { perimeter > 42 }
# SQL: SELECT `circles`.* FROM `circles`  WHERE (6.283185307179586 * `circles`.`radius` > 42)
Circle.where { area < 42 }
# SQL: SELECT `circles`.* FROM `circles`  WHERE (3.141592653589793 * `circles`.`radius` * `circles`.`radius` < 42)

class Product < ActiveRecord::Base
  predicate = (attribute(:name) == nil) & ~category.in(%w( shoes shirts ))
  puts predicate.to_sql
  # `products`.`name` IS NULL AND NOT (`products`.`category` IN ('shoes', 'shirts'))

  where(predicate).all
  # SQL: SELECT `products`.* FROM `products` WHERE `products`.`name` IS NULL AND
  #      NOT (`products`.`category` IN ('shoes', 'shirts'))
end
```

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
- Add support for block syntax on `where.not` clause
- Drop support for ActiveRecord < 4
- Add support for ActiveRecord 5

Copyright
---------

SexyScopes is released under the [MIT License](http://www.opensource.org/licenses/MIT).

Copyright (c) 2010-2014 Samuel Lebeau, See LICENSE for details.
