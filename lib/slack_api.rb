# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'

class SlackApi
  def initialize
    @base_uri = 'https://slack.com/api'
    @token = ENV['SLACK_TOKEN']
    @channel_id = ENV['SLACK_CHANNEL_ID']
  end

  def send_message(message)
    return puts 'Sending simulated Slack message...' if ENV['RUBY_ENV'] == 'test'

    response = post('chat.postMessage', { channel: @channel_id, text: message })
    response_body = JSON.parse(response.read_body)
    return if response.code == '200' && response_body['ok']

    raise "Could not send Slack message. Response from Slack: #{response_body}"
  end

  private

  def post(endpoint, body)
    uri = URI.parse("#{@base_uri}/#{endpoint}")
    headers = {
      'Authorization': "Bearer #{@token}",
      'Content-Type': 'application/json'
    }
    Net::HTTP.post(uri, body.to_json, headers)
  end
end
