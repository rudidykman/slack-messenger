# frozen_string_literal: true

require_relative './helpers'
require_relative './errors'
require_relative './notification'
require 'json'

def post_notifications(event:, context:)
  authorize(event['headers'])
  body = JSON.parse(event['body'] || '{}')
  validate_request_body(body)

  Notification.new(message: body['message'], from_name: body['from_name']).send
  { statusCode: 200 }
rescue UnauthorizedError => e
  {
    statusCode: 401,
    body: { message: e.message }.to_json
  }
rescue InvalidRequestError => e
  {
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
