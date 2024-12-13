# frozen_string_literal: true

RSpec.configure do |config|
  config.before { TestHelpers::DynamoDBTable.instance.reset }
end
