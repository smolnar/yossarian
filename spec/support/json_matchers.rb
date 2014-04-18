RSpec::Matchers.define :eql_as_json do |expected|
  match do |actual|
    json = JSON.parse(actual, symbolize_names: true)

    json == expected
  end
end
