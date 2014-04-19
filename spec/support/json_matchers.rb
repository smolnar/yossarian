RSpec::Matchers.define :eql_as_json do |expected|
  match do |actual|
    hash = JSON.parse(actual, symbolize_names: true)

    expect(hash).to eql(expected)
  end
end
