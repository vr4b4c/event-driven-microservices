require 'json'
require 'logger'

# @param event [Hash]
# @param context [LambdaContext]
def handler (event:, context:)
  JSON.generate(
    event: event.inspect,
    context: context.inspect
  )
end
