# frozen_string_literal: true

require_relative './helpers'
require_relative './errors'
require_relative './notification'
require 'json'

def authorize(event:, context:)
  authorize_request(event)
end

def post_notifications(event:, context:)
  body = JSON.parse(event['body'] || '{}')
  validate_request_body(body)

  Notification.new(message: body['message'], from_name: body['from_name']).send
  { statusCode: 200 }
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
