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
    normalize_sql actual.to_sql
  end

  # Arel < 6 seems to inserts an additionnal (harmless) space before the WHERE clause.
  # We ensure this space is removed to avoid false positives.
  def normalize_sql(sql)
    sql.gsub('  WHERE ', ' WHERE ')
  end
end
