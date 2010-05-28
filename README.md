sexy_scopes
===========

sexy_scope is a small wrapper around `Arel::Attribute` that adds a little syntactic
sugar when creating scopes in ActiveRecord.
It adds an `attribute` class method which takes an attribute name and returns an 
`Arel::Attribute` wrapper, which responds to common operators to return predicates
objects that can be used as arguments to `ActiveRecord::Base.where`.

Examples
--------

    class Product < ActiveRecord::Base
      scope :untitled, where(attribute(:name) == nil)
      
      def self.cheaper_than(price)
        where attribute(:price) < price
      end
      
      def self.search(term)
        where attribute(:name) =~ "%#{term}%"
      end
    end

Classic `Arel::Attribute` methods (`lt`, `in`, `matches`, `not`, etc.) are still available
and predicates can be chained using `and` and `or`:

    (Product.attribute(:name) == nil).and(Product.attribute(:category).in(["foo", "bar"])).to_sql
    # => ("products"."name" IS NULL AND "products"."category" IN ('foo', 'bar'))

Copyright
---------

Copyright (c) 2010 Samuel Lebeau. See LICENSE for details.
