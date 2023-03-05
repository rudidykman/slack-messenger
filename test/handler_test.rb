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
    hard_bounce_notification = {
      Type: 'HardBounce',
      Description: 'The server was unable to deliver your message (ex: unknown user, mailbox not found).',
      Email: 'arthur@example.com'
    }.to_json
    response = handler(event: { 'body' => hard_bounce_notification }, context: {})
    assert_equal 400, response[:statusCode]
    assert_match("Alerts are only sent reports of type '#{SPAM_NOTIFICATION_TYPE}'.", response[:body])
  end

  def test_no_body
    response = handler(event: {}, context: {})
    assert_equal 400, response[:statusCode]
  end

  def test_missing_parameter
    partial_body = {
      Type: 'SpamNotification',
      Email: 'zaphod@example.com'
    }.to_json
    response = handler(event: { 'body' => partial_body }, context: {})
    assert_equal 400, response[:statusCode]
  end
end
