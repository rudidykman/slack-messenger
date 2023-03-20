# frozen_string_literal: true

require_relative '../lib/handler'
require 'test/unit'
require 'json'

class TestHandler < Test::Unit::TestCase
  def test_success
    response = post_notifications(
      event: {
        'body' => { message: 'Test' }.to_json,
        'headers' => { 'Authorization' => "Bearer #{ENV['TOKEN']}" }.to_json
      },
      context: {}
    )
    assert_equal 200, response[:statusCode]
  end

  def test_unauthorized
    response = post_notifications(event: {}, context: {})
    assert_equal 401, response[:statusCode]
  end

  def test_no_body
    response = post_notifications(
      event: {
        'headers' => { 'Authorization' => "Bearer #{ENV['TOKEN']}" }.to_json
      },
      context: {}
    )
    assert_equal 400, response[:statusCode]
  end

  def test_missing_required_field
    response = post_notifications(
      event: {
        'body' => { from_name: 'Test' }.to_json,
        'headers' => { 'Authorization' => "Bearer #{ENV['TOKEN']}" }.to_json
      },
      context: {}
    )
    assert_equal 400, response[:statusCode]
  end

  def test_contains_invalid_field
    response = post_notifications(
      event: {
        'body' => { message: 'Test', from_name: 'Test', invalid: true }.to_json,
        'headers' => { 'Authorization' => "Bearer #{ENV['TOKEN']}" }.to_json
      },
      context: {}
    )
    assert_equal 400, response[:statusCode]
  end
end
