# frozen_string_literal: true

require_relative 'lib/handler'
require_relative 'lib/slack_api'

task :test do
  ENV['RUBY_ENV'] = 'test'
  ENV['TOKEN'] = 'test_token'
  ruby 'test/handler_test.rb'
end

task :invoke do
  payload = File.open('payload.json').read
  response = post_notifications(
    event: {
      'body' => payload,
      'headers' => { 'Authorization' => "Bearer #{ENV['TOKEN']}" }.to_json
    },
    context: {}
  )
  puts "Response code: #{response[:statusCode]}"
  puts "Response body: #{response[:body]}"
end

task :channel_id, [:channel_name] do |_task, args|
  channel = SlackApi.new.channels.find { |c| c['name'] == args[:channel_name] }
  puts channel['id']
end
