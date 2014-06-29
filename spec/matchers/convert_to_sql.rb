RSpec::Matchers.define :convert_to_sql do |expected|
  match do |actual|
    actual.to_sql == convert_expected_sql(expected)
  end
  
  description do
    "convert to the following SQL: #{convert_expected_sql(expected)}"
  end
  
  failure_message_for_should do |actual|
    "expected generated SQL to be \n  #{convert_expected_sql(expected)}\ngot\n  #{actual.to_sql}"
  end
  
  def convert_expected_sql(expected)
    case SexyScopesSpec.database_system
    when 'mysql'
      expected.gsub('"', '`')
    when 'postgresql'
      expected.gsub('LIKE', 'ILIKE')
    else
      expected
    end
  end
end
