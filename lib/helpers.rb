# frozen_string_literal: true

require_relative './errors'

def authorize_request(event)
  effect = event['authorizationToken'] == "Bearer #{ENV['TOKEN']}" ? 'Allow' : 'Deny'

  {
    principalId: 'PostNotification',
    policyDocument: {
      Version: '2012-10-17',
      Statement: [
        {
          Action: 'execute-api:Invoke',
          Effect: effect,
          Resource: event['methodArn']
        }
      ]
    }
  }
end

def validate_request_body(body)
  raise InvalidRequestError, 'Request body is missing required field "message".' if body['message'].nil?

  allowed_fields = %w[message from_name]
  invalid_fields = []
  body.each_key do |key|
    invalid_fields.push(key) unless allowed_fields.include?(key)
  end
  if invalid_fields.length > 0
    raise InvalidRequestError, "Request body contains invalid fields: #{invalid_fields}."
  end
end
