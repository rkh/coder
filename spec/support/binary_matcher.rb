RSpec::Matchers.define :binary_equal do |expected|
  match { |actual| actual.bytes.to_a == expected.bytes.to_a }
  diffable
end
