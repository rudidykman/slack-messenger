# frozen_string_literal: true

require_relative './spam_notification'
require 'json'

SPAM_NOTIFICATION_TYPE = 'SpamNotification'

def handler(event:, context:)
  body = JSON.parse(event['body'])
  unless body['Type'] == SPAM_NOTIFICATION_TYPE
    return {
      statusCode: 400,
      body: { message: "Alerts are only sent reports of type '#{SPAM_NOTIFICATION_TYPE}'." }.to_json
    }
  end

  SpamNotification.new(body['Description'], body['Email']).send_alert
  { statusCode: 200 }
rescue StandardError => e
  puts e
  {
    statusCode: 500,
    body: { message: 'An internal error ocurred.' }.to_json
  }
end
