# frozen_string_literal: true

require 'singleton'

module TestHelpers
  class DynamoDBTable
    include ::Singleton

    # @return [Array<Object>]
    attr_reader :items

    def initialize
      @items = []
    end

    # @param item [Object]
    # @return [void]
    def put_item(item:) = items << item

    # @return [void]
    def reset = @items = []
  end
end
