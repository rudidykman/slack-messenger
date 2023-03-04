# frozen_string_literal: true

require_relative '../lib/handler'
require 'test/unit'
require 'json'

class TestHandler < Test::Unit::TestCase
  def test_spam_notification
    spam_notification = {
      Type: 'SpamNotification',
      Description: 'The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.',
      Email: 'zaphod@example.com'
    }.to_json
    response = handler(event: { 'body' => spam_notification }, context: {})
    assert_equal 200, response[:statusCode]
  end

  def test_hard_bounce
    response = handler(event: { 'body' => { Type: 'HardBounce' }.to_json }, context: {})
    assert_equal 400, response[:statusCode]
    assert_match("Alerts are only sent reports of type '#{SPAM_NOTIFICATION_TYPE}'.", response[:body])
  end
end
