RSpec::Matchers.define :convert_to_sql do |expected|
  match do |actual|
    actual.to_sql == expected
  end
  
  description do
    "convert to the following SQL: #{expected}"
  end
  
  failure_message_for_should do |actual|
    "expected generated SQL to be \n  #{expected}\ngot\n  #{actual.to_sql}"
  end
end
