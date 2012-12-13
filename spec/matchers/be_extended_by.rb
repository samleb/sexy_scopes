RSpec::Matchers.define :be_extended_by do |expected|
  match do |actual|
    extended_modules = actual.singleton_class.included_modules
    extended_modules.include?(expected)
  end
end
