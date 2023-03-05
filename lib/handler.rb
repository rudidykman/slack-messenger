# frozen_string_literal: true

require_relative './validation'
require_relative './spam_notification'
require 'json'

def handler(event:, context:)
  body = JSON.parse(event['body'] || '{}')
  validate_request_body(body)

  SpamNotification.new(body['Description'], body['Email']).send_alert
  { statusCode: 200 }
rescue InvalidRequestError => e
  return {
    statusCode: 400,
    body: { message: e.message }.to_json
  }
rescue StandardError => e
  puts e
  {
    statusCode: 500,
    body: { message: 'An internal error ocurred.' }.to_json
  }
end
