# frozen_string_literal: true

require_relative '../lib/handler'
require 'test/unit'
require 'json'

class TestHandler < Test::Unit::TestCase
  def test_valid_token
    response = authorize(event: { 'authorizationToken' => "Bearer #{ENV['TOKEN']}" }, context: {})
    policyDocument = response[:policyDocument]
    assert_equal policyDocument[:Statement].first[:Effect], 'Allow'
  end

  def test_invalid_token
    response = authorize(event: { 'authorizationToken' => 'Bearer INVALID' }, context: {})
    policyDocument = response[:policyDocument]
    assert_equal policyDocument[:Statement].first[:Effect], 'Deny'
  end

  def test_no_token
    response = authorize(event: {}, context: {})
    policyDocument = response[:policyDocument]
    assert_equal policyDocument[:Statement].first[:Effect], 'Deny'
  end

  def test_success
    response = post_notifications(
      event: {
        'body' => { message: 'Test' }.to_json
      },
      context: {}
    )
    assert_equal 200, response[:statusCode]
  end

  def test_no_body
    response = post_notifications(
      event: {},
      context: {}
    )
    assert_equal 400, response[:statusCode]
  end

  def test_missing_required_field
    response = post_notifications(
      event: {
        'body' => { from_name: 'Test' }.to_json
      },
      context: {}
    )
    assert_equal 400, response[:statusCode]
  end

  def test_contains_invalid_field
    response = post_notifications(
      event: {
        'body' => { message: 'Test', from_name: 'Test', invalid: true }.to_json
      },
      context: {}
    )
    assert_equal 400, response[:statusCode]
  end
end
