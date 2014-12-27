RSpec::Matchers.define :convert_to_sql do |expected|
  case SexyScopesSpec.database_system
  when 'mysql'
    expected = expected.gsub('"', '`')
  when 'postgresql'
    expected = expected.gsub('LIKE', 'ILIKE')
  end

  match do |actual|
    convert_to_sql(actual) == expected
  end

  description do
    "convert to the following SQL: #{expected}"
  end

  failure_message do |actual|
    "expected generated SQL to be \n  #{expected}\ngot\n  #{convert_to_sql(actual)}"
  end

  def convert_to_sql(actual)
    normalize_sql to_unprepared_sql(actual)
  end

  # In ActiveRecord 4.0 and 4.1, when the adapter supports prepared statements, calling `to_sql` on
  # a `has_many` association collection proxy returns a statement with "?" instead of the actual foreign key:
  #
  #     SELECT "messages".* FROM "messages" WHERE "messages"."author_id" = ?
  #
  # Here we ensure we always get the unprepared statement.
  def to_unprepared_sql(actual)
    connection = actual.respond_to?(:connection) && actual.connection
    if connection && connection.respond_to?(:unprepared_statement)
      connection.unprepared_statement { actual.to_sql }
    else
      actual.to_sql
    end
  end

  # Arel < 6 seems to inserts an additionnal (harmless) space before the WHERE clause.
  # We ensure this space is removed to avoid false positives.
  def normalize_sql(sql)
    sql.gsub('  WHERE ', ' WHERE ')
  end
end
