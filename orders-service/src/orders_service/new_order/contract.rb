# frozen_string_literal: true

module OrdersService
  module NewOrder
    class Contract < Dry::Validation::Contract
      params do
        required(:customer_id).filled(:string)
        required(:total).filled(:integer).value(:integer)
      end

      rule(:total) do
        key.failure('must be positive') if value < 0
      end
    end
  end
end
