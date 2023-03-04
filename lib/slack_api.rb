# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'

class SlackApi
  def initialize
    @base_uri = 'https://slack.com/api'
    @token = ENV['SLACK_TOKEN']
  end

  def send_message(message, channel_id = ENV['SLACK_CHANNEL_ID'])
    return puts 'Sending simulated Slack message...' if ENV['RUBY_ENV'] == 'test'

    post('chat.postMessage', { channel: channel_id, text: message })
  end

  def channels
    get('conversations.list')['channels']
  end

  private

  def post(endpoint, body)
    uri = URI.parse("#{@base_uri}/#{endpoint}")
    headers = {
      'Authorization': "Bearer #{@token}",
      'Content-Type': 'application/json'
    }
    response = Net::HTTP.post(uri, body.to_json, headers)
    parse_response(response)
  end

  def get(endpoint)
    uri = URI.parse("#{@base_uri}/#{endpoint}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{@token}"
    response = http.request(request)
    parse_response(response)
  end

  def parse_response(response)
    response_body = JSON.parse(response.read_body)
    return response_body if response.code == '200' && response_body['ok']

    raise "Slack API request failed. Response from Slack: #{response_body}"
  end
end
